using Microsoft.MixedReality.Toolkit;
using Microsoft.MixedReality.Toolkit.Input;
using Microsoft.MixedReality.Toolkit.Utilities;
using Microsoft.MixedReality.Toolkit.Utilities.Solvers;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

/// <summary>
/// A scrollable frame where content scroll is triggered by manual controller click and drag or according to pagination settings.
/// </summary>
/// <remarks>Executing also in edit mode to properly catch and mask any new content added to scroll container.</remarks>
[ExecuteAlways]
public class ScrollingVolume : MonoBehaviour,
    IMixedRealityPointerHandler,
    IMixedRealitySourceStateHandler,
    IMixedRealityTouchHandler
{
    /// <summary>
    /// How velocity is applied to a <see cref="ScrollingObjectCollection"/> when a scroll is released.
    /// </summary>
    public enum VelocityType
    {
        FalloffPerFrame = 0,
        None
    }

    [SerializeField]
    [Tooltip("Enables/disables scrolling with near/far interaction.")]
    private bool canScroll = true;

    /// <summary>
    /// Enables/disables scrolling with near/far interaction.
    /// </summary>
    /// <remarks>Helpful for controls where you may want pagination or list movement without freeform scrolling.</remarks>
    public bool CanScroll
    {
        get { return canScroll; }
        set { canScroll = value; }
    }

    // Helps catching any changes on the mask enabled value made from the inspector.
    // With the custom editor, the mask enabled field is changed before mask enabled setter is called.
    private bool wasMaskEnabled = true;

    [SerializeField]
    [Tooltip("The distance, in meters, the current pointer can travel along the scroll direction before triggering a scroll drag.")]
    [Range(0.0f, 0.2f)]
    private float handDeltaScrollThreshold = 0.02f;

    /// <summary>
    /// The distance, in meters, the current pointer can travel along the scroll direction before triggering a scroll drag.
    /// </summary>
    public float HandDeltaScrollThreshold
    {
        get { return handDeltaScrollThreshold; }
        set { handDeltaScrollThreshold = value; }
    }

    [SerializeField]
    [Tooltip("Withdraw amount, in meters, from the front of the scroll boundary needed to transition from touch engaged to released.")]
    private float releaseThresholdFront = 0.03f;
    /// <summary>
    /// Withdraw amount, in meters, from the front of the scroll boundary needed to transition from touch engaged to released.
    /// </summary>
    public float ReleaseThresholdFront
    {
        get { return releaseThresholdFront; }
        set { releaseThresholdFront = value; }
    }

    [SerializeField]
    [Tooltip("Withdraw amount, in meters, from the back of the scroll boundary needed to transition from touch engaged to released.")]
    private float releaseThresholdBack = 0.20f;
    /// <summary>
    /// Withdraw amount, in meters, from the back of the scroll boundary needed to transition from touch engaged to released.
    /// </summary>
    public float ReleaseThresholdBack
    {
        get { return releaseThresholdBack; }
        set { releaseThresholdBack = value; }
    }

    [SerializeField]
    [Tooltip("Withdraw amount, in meters, from the right or left of the scroll boundary needed to transition from touch engaged to released.")]
    private float releaseThresholdLeftRight = 0.20f;
    /// <summary>
    /// Withdraw amount, in meters, from the right or left of the scroll boundary needed to transition from touch engaged to released.
    /// </summary>
    public float ReleaseThresholdLeftRight
    {
        get { return releaseThresholdLeftRight; }
        set { releaseThresholdLeftRight = value; }
    }

    [SerializeField]
    [Tooltip("Withdraw amount, in meters, from the top or bottom of the scroll boundary needed to transition from touch engaged to released.")]
    private float releaseThresholdTopBottom = 0.20f;
    /// <summary>
    /// Withdraw amount, in meters, from the top or bottom of the scroll boundary needed to transition from touch engaged to released.
    /// </summary>
    public float ReleaseThresholdTopBottom
    {
        get { return releaseThresholdTopBottom; }
        set { releaseThresholdTopBottom = value; }
    }

    [SerializeField]
    [Tooltip("Distance, in meters, to position a local xy plane used to verify if a touch interaction started in the front of the scroll view.")]
    [Range(0.0f, 0.05f)]
    private float frontTouchDistance = 0.005f;
    /// <summary>
    /// Distance, in meters, to position a local xy plane used to verify if a touch interaction started in the front of the scroll view.
    /// </summary>
    public float FrontTouchDistance
    {
        get { return frontTouchDistance; }
        set { frontTouchDistance = value; }
    }



    [SerializeField]
    [Tooltip("Amount of (extra) velocity to be applied to scroller")]
    [Range(0.0f, 0.02f)]
    private float velocityMultiplier = 0.008f;

    /// <summary>
    /// Amount of (extra) velocity to be applied to scroller.
    /// </summary>
    /// <remarks>Helpful if you want a small movement to fling the list.</remarks>
    public float VelocityMultiplier
    {
        get { return velocityMultiplier; }
        set { velocityMultiplier = value; }
    }

    [SerializeField]
    [Tooltip("Amount of falloff applied to velocity")]
    [Range(0.0001f, 0.9999f)]
    private float velocityDampen = 0.90f;

    /// <summary>
    /// Amount of drag applied to velocity.
    /// </summary>
    /// <remarks>This can't be 0.0f since that won't allow ANY velocity - set <see cref="TypeOfVelocity"/> to <see cref="VelocityType.None"/>. It can't be 1.0f since that won't allow ANY drag.</remarks>
    public float VelocityDampen
    {
        get { return velocityDampen; }
        set { velocityDampen = value; }
    }

    [SerializeField]
    [Tooltip("The desired type of velocity for the scroller.")]
    private VelocityType typeOfVelocity;

    /// <summary>
    /// The desired type of velocity for the scroller.
    /// </summary>
    public VelocityType TypeOfVelocity
    {
        get { return typeOfVelocity; }
        set { typeOfVelocity = value; }
    }


    [SerializeField]
    [Tooltip("Multiplier to add more bounce to the overscroll of a list when using VelocityType.FalloffPerFrame or VelocityType.FalloffPerItem.")]
    private float bounceMultiplier = 0.1f;

    /// <summary>
    /// Multiplier to add more bounce to the overscroll of a list when using <see cref="VelocityType.FalloffPerFrame"/> or <see cref="VelocityType.FalloffPerItem"/>.
    /// </summary>
    public float BounceMultiplier
    {
        get { return bounceMultiplier; }
        set { bounceMultiplier = value; }
    }

    // Lerping time interval used for smoothing between positions during scroll drag. Number was empirically defined.
    private const float DragLerpInterval = 0.5f;

    // Lerping time interval used for smoothing between positions during scroll drag passed max and min scroll positions. Number was empirically defined.
    private const float OverDampLerpInterval = 0.9f;

    // Lerping time interval used for smoothing between positions during bouncing. Number was empirically defined.
    private const float BounceLerpInterval = 0.2f;

    /// <summary>
    /// The UnityEvent type the ScrollingObjectCollection sends.
    /// GameObject is the object the fired the scroll.
    /// </summary>
    [System.Serializable]
    public class ScrollEvent : UnityEvent<GameObject> { }

    /// <summary>
    /// Event that is fired on the target object when the ScrollingObjectCollection deems event as a Click.
    /// </summary>
    [Tooltip("Event that is fired on the target object when the ScrollingObjectCollection deems event as a Click.")]
    public ScrollEvent OnClick = new ScrollEvent();

    /// <summary>
    /// Event that is fired on the target object when the ScrollingObjectCollection is touched.
    /// </summary>
    [Tooltip("Event that is fired on the target object when the ScrollingObjectCollection is touched.")]
    public ScrollEvent OnTouchStarted = new ScrollEvent();

    /// <summary>
    /// Event that is fired on the target object when the ScrollingObjectCollection is no longer touched.
    /// </summary>
    [Tooltip("Event that is fired on the target object when the ScrollingObjectCollection is no longer touched.")]
    public ScrollEvent OnTouchEnded = new ScrollEvent();

    /// <summary>
    /// Event that is fired on the target object when the ScrollingObjectCollection is no longer in motion from velocity
    /// </summary>
    [Tooltip("Event that is fired on the target object when the ScrollingObjectCollection is no longer in motion from velocity.")]
    public UnityEvent OnMomentumEnded = new UnityEvent();

    /// <summary>
    /// Event that is fired on the target object when the ScrollingObjectCollection is starting motion with velocity.
    /// </summary>
    [Tooltip("Event that is fired on the target object when the ScrollingObjectCollection is starting motion with velocity.")]
    public UnityEvent OnMomentumStarted = new UnityEvent();

    // Minimum amount the scroller can travel (vertically) - this will always be zero. Here for readability
    private readonly float minY = 0.0f;

    // Maximum amount the scroller can travel (horizontally) - this will always be zero. Here for readability
    private readonly float maxX = 0.0f;
    
    #region scroll state variables

    /// <summary>
    /// Tracks whether content or scroll background is being interacted with.
    /// </summary>
    public bool IsEngaged { get; private set; } = false;

    /// <summary>
    /// Tracks whether the scroll is being dragged due to a controller movement.
    /// </summary>
    public bool IsDragging { get; private set; } = false;

    /// <summary>
    /// Tracks whether the scroll content or background is touched by a near pointer.
    /// Remains true while the same near pointer does not cross the scrolling release boundaries.
    /// </summary>
    public bool IsTouched { get; private set; } = false;

    /// <summary>
    /// Tracks whether the scroll has any kind of momentum.
    /// True if scroll is being dragged by a controller, the velocity is falling off after a drag release or during pagination movement.
    /// </summary>
    public bool HasMomentum { get; private set; } = false;

    private Vector3 initialRotation;

    // The new of the scollContainer before we've set the position / finished the updateloop
    private Vector3 workingRotation;
    
    private IMixedRealityPointer currentPointer;

    // The initial focused object from scroll content. This may not always be currentPointer.Result.CurrentPointerTarget
    private GameObject initialFocusedObject;

    private bool oldIsTargetPositionLockedOnFocusLock;

    #endregion scroll state variables

    #region drag position calculation variables

    // Hand position when starting a motion
    private Vector3 initialPointerPos;

    // Hand position previous frame
    private Vector3 lastPointerPos;

    #endregion drag position calculation variables

    #region velocity calculation variables

    // Simple velocity of the scroller: current - last / timeDelta
    private float scrollVelocity = 0.0f;

    // Filtered weight of scroll velocity
    private float avgVelocity = 0.0f;

    // How much we should filter the velocity - yes this is a magic number. Its been tuned so lets leave it.
    private readonly float velocityFilterWeight = 0.97f;

    // Simple state enum to handle velocity falloff logic
    private enum VelocityState
    {
        None = 0,
        Resolving,
        Calculating,
        Dragging,
        Animating,
    }

    // Internal enum for tracking the velocity state of the list
    private VelocityState currentVelocityState;

    private VelocityState CurrentVelocityState
    {
        get => currentVelocityState;

        set
        {
            if (value != currentVelocityState)
            {
                if (value == VelocityState.None)
                {
                    OnMomentumEnded.Invoke();
                }
                else if (currentVelocityState == VelocityState.None)
                {
                    OnMomentumStarted.Invoke();
                }
                previousVelocityState = currentVelocityState;
                currentVelocityState = value;
            }
        }
    }

    private VelocityState previousVelocityState;

    // Pre calculated destination with velocity and falloff when using per item snapping
    private Vector3 velocityDestinationPos;

    // Velocity container for storing previous filtered velocity
    private float velocitySnapshot;

    #endregion velocity calculation variables

    // The Animation CoRoutine
    private IEnumerator animateScroller;

    #region MonoBehaviour Implementation

    private void OnEnable()
    {
        // Register for global input events
        CoreServices.InputSystem?.RegisterHandler<IMixedRealitySourceStateHandler>(this);
        CoreServices.InputSystem?.RegisterHandler<IMixedRealityTouchHandler>(this);
        CoreServices.InputSystem?.RegisterHandler<IMixedRealityPointerHandler>(this);
    }

    private void Update()
    {
        if (!Application.isPlaying)
        {
            return;
        }

        // The scroller has detected input and has a valid pointer
        if (IsEngaged && TryGetPointerPositionOnPlane(out Vector3 currentPointerPos))
        {
            Vector3 handDelta = initialPointerPos - currentPointerPos;
            handDelta = transform.InverseTransformDirection(handDelta);

            if (IsDragging && currentPointer != null) // Changing lock after drag started frame to allow for focus provider to move pointer focus to scroll background before locking
            {
                currentPointer.IsFocusLocked = true;
            }

            // Lets see if this is gonna be a click or a drag
            // Check the scroller's length state to prevent resetting calculation
            if (!IsDragging)
            {
                // Grab the delta value we care about
                float absAxisHandDelta = Mathf.Abs(handDelta.x);

                // Catch an intentional finger in scroller to stop momentum, this isn't a drag its definitely a stop
                if (absAxisHandDelta > handDeltaScrollThreshold)
                {
                    scrollVelocity = 0.0f;
                    avgVelocity = 0.0f;

                    IsDragging = true;
                    handDelta = Vector3.zero;

                    CurrentVelocityState = VelocityState.Dragging;

                    initialRotation = workingRotation = transform.localEulerAngles;
                    initialPointerPos = currentPointerPos;
                }
            }

            if (IsTouched) // && DetectScrollRelease(currentPointerPos))
            {
                // We're on the other side of the original touch position. This is a release.
                if (IsDragging)
                {
                    // Its a drag release
                    initialRotation = workingRotation;
                    CurrentVelocityState = VelocityState.Calculating;
                }
                else
                {
                    // Its a click release
                    OnClick?.Invoke(initialFocusedObject);
                }

                ResetInteraction();
            }
            else if (IsDragging && canScroll)
            {

                // Lock Y, clamp X
                float handLocalDelta = SafeDivisionFloat(handDelta.x, transform.lossyScale.x);

                workingRotation.x = MathUtilities.CLampLerp(initialRotation.x - handLocalDelta, -360f, maxX, DragLerpInterval);

                workingRotation.y = 0.0f;

                // Update the rotation
                ApplyRotation(workingRotation);

                CalculateVelocity();

                // Update the prev val for velocity
                lastPointerPos = currentPointerPos;
            }
        }
        else if ((CurrentVelocityState != VelocityState.None
                  || previousVelocityState != VelocityState.None)
                  && CurrentVelocityState != VelocityState.Animating) // Prevent the Animation coroutine from being overridden
        {
            // We're not engaged, so handle any not touching behavior
            HandleVelocityFalloff();

            // Apply our position
            ApplyRotation(workingRotation);
        }

        // Setting HasMomentum to true if scroll velocity state has changed or any movement happened during this update
        if (CurrentVelocityState != VelocityState.None || previousVelocityState != VelocityState.None)
        {
            HasMomentum = true;
        }

        else
        {
            HasMomentum = false;
        }

        previousVelocityState = CurrentVelocityState;
    }

    private void OnDisable()
    {
        // Unregister global input events
        CoreServices.InputSystem?.UnregisterHandler<IMixedRealitySourceStateHandler>(this);
        CoreServices.InputSystem?.UnregisterHandler<IMixedRealityTouchHandler>(this);
        CoreServices.InputSystem?.UnregisterHandler<IMixedRealityPointerHandler>(this);
    }

    #endregion MonoBehaviour Implementation

    #region private methods

    /// <summary>
    /// Gets the cursor position (pointer end point) on the scrollable plane,
    /// projected onto the direction being scrolled if far pointer.
    /// Returns false if the pointer is null.
    /// </summary>
    private bool TryGetPointerPositionOnPlane(out Vector3 result)
    {
        result = Vector3.zero;

        if (((MonoBehaviour)currentPointer) == null)
        {
            return false;
        }
        if (currentPointer.GetType() == typeof(PokePointer))
        {
            result = currentPointer.Position;
            return true;
        }

        var scrollVector = transform.right;

        result = transform.position + Vector3.Project(currentPointer.Position - transform.position, scrollVector);
        return true;
    }

    /// <summary>
    /// Calculates our <see cref="VelocityType"/> falloff
    /// </summary>
    private void HandleVelocityFalloff()
    {
        switch (typeOfVelocity)
        {
            case VelocityType.FalloffPerFrame:

                HandleFalloffPerFrame();
                break;
                
            case VelocityType.None:

                CurrentVelocityState = VelocityState.None;

                avgVelocity = 0.0f;
                break;
        }
    }
    
    /// <summary>
    /// Handles <see cref="ScrollingObjectCollection"/> drag release behavior when <see cref="TypeOfVelocity"/> is set to <see cref="VelocityType.FalloffPerFrame"/>
    /// </summary>
    private void HandleFalloffPerFrame()
    {
        switch (CurrentVelocityState)
        {
            case VelocityState.Calculating:

                workingRotation.x = initialRotation.x + avgVelocity;

                CurrentVelocityState = VelocityState.Resolving;

                // clean up our position for next frame
                initialRotation = workingRotation;
                break;

            case VelocityState.Resolving:

                avgVelocity *= velocityDampen;
                workingRotation.x = initialRotation.x + avgVelocity;

                SnapVelocityFinish();

                // clean up our position for next frame
                initialRotation = workingRotation;

                break;
        }
    }

    private void SnapVelocityFinish()
    {
        if (Vector3.Distance(transform.localEulerAngles, workingRotation) > Mathf.Epsilon)
        {
            return;
        }

        CurrentVelocityState = VelocityState.None;
        avgVelocity = 0.0f;

        // clean up our position for next frame
        initialRotation = workingRotation;
    }

    /// <summary>
    /// Wrapper for per frame velocity calculation and filtering.
    /// </summary>
    private void CalculateVelocity()
    {
        // Update simple velocity
        TryGetPointerPositionOnPlane(out Vector3 newPos);

        scrollVelocity = (newPos.x - lastPointerPos.x) / Time.deltaTime * velocityMultiplier;

        // And filter it...
        avgVelocity = (avgVelocity * (1.0f - velocityFilterWeight)) + (scrollVelocity * velocityFilterWeight);
    }

    /*
    /// <summary>
    /// Checks if the engaged joint has released the scrollable list
    /// </summary>
    private bool DetectScrollRelease(Vector3 pointerPos)
    {
        Vector3 scrollToPointerVector = pointerPos - ClipBox.transform.position;

        // Projecting vector onto every clip box space coordinate and using clip box lossy scale as reference to dimensions to scroll view visible bounds
        // Using dot product to check if pointer is in front or behind the scroll view plane
        bool isScrollRelease = Vector3.Magnitude(Vector3.Project(scrollToPointerVector, ClipBox.transform.up)) > ClipBox.transform.lossyScale.y / 2 + releaseThresholdTopBottom
                            || Vector3.Magnitude(Vector3.Project(scrollToPointerVector, ClipBox.transform.right)) > ClipBox.transform.lossyScale.x / 2 + releaseThresholdLeftRight

                            || (Vector3.Dot(scrollToPointerVector, transform.forward) > 0 ?
                                    Vector3.Magnitude(Vector3.Project(scrollToPointerVector, ClipBox.transform.forward)) > ClipBox.transform.lossyScale.z / 2 + releaseThresholdBack :
                                    Vector3.Magnitude(Vector3.Project(scrollToPointerVector, ClipBox.transform.forward)) > ClipBox.transform.lossyScale.z / 2 + releaseThresholdFront);
        return isScrollRelease;
    }
    */
    private bool HasPassedThroughFrontPlane(PokePointer pokePointer)
    {
        var p = transform.InverseTransformPoint(pokePointer.PreviousPosition);
        return p.z <= -FrontTouchDistance;
    }

    /// <summary>
    /// Helper to perform division operations and prevent division by 0.
    /// </summary>
    private static int SafeDivisionInt(int numerator, int denominator)
    {
        return (denominator != 0) ? numerator / denominator : 0;
    }

    private float SafeDivisionFloat(float numerator, float denominator)
    {
        return (denominator != 0) ? numerator / denominator : 0;
    }
    
    /// <summary>
    /// Precalculates the total amount of travel given the scroller's current average velocity and drag.
    /// </summary>
    /// <param name="steps"><see cref="out"/> Number of steps to get our <see cref="avgVelocity"/> to effectively "zero" (0.00001).</param>
    /// <returns>The total distance the <see cref="avgVelocity"/> with <see cref="velocityDampen"/> as drag would travel.</returns>
    private float IterateFalloff(float vel, out int steps)
    {
        // Some day this should be a falloff formula, below is the number of steps. Just can't figure out how to get the right velocity.
        // float numSteps = (Mathf.Log(0.00001f)  - Mathf.Log(Mathf.Abs(avgVelocity))) / Mathf.Log(velocityFalloff);

        float newVal = 0.0f;
        float v = vel;
        steps = 0;

        while (Mathf.Abs(v) > 0.00001)
        {
            v *= velocityDampen;
            newVal += v;
            steps++;
        }

        return newVal;
    }

    /// <summary>
    /// Applies <paramref name="workingRot"/> to the <see cref="Transform.localPosition"/> of our <see cref="scrollContainer"/>
    /// </summary>
    /// <param name="workingRot">The new desired position for <see cref="scrollContainer"/> in local space</param>
    private void ApplyRotation(Vector3 workingRot)
    {
        Vector3 newRotation = new Vector3(workingRot.x, transform.localEulerAngles.y, 0.0f);

        transform.localEulerAngles = newRotation;
    }

    private void ResetInteraction()
    {
        OnTouchEnded?.Invoke(initialFocusedObject);

        // Release the pointer
        if (currentPointer != null) currentPointer.IsFocusLocked = false;
        Debug.Log("Set currentPointer to null via ResetInteraction");
        currentPointer = null;
        initialFocusedObject = null;

        // Clear our states
        IsTouched = false;
        IsEngaged = false;
        IsDragging = false;
    }

    /// <summary>
    /// Resets the scroll offset state of the ScrollingObjectCollection.
    /// </summary>
    private void ResetScrollOffset()
    {
        workingRotation = Vector3.zero;
        ApplyRotation(workingRotation);
    }

    #endregion private methods


    #region IMixedRealityPointerHandler implementation

    /// <inheritdoc/>
    void IMixedRealityPointerHandler.OnPointerUp(MixedRealityPointerEventData eventData)
    {
        if (currentPointer == null || eventData.Pointer.PointerId != currentPointer.PointerId)
        {
            return;
        }

        // Release the pointer
        currentPointer.IsTargetPositionLockedOnFocusLock = oldIsTargetPositionLockedOnFocusLock;

        if (!IsTouched && IsEngaged && animateScroller == null)
        {
            if (IsDragging)
            {
                // Its a drag release
                initialRotation = workingRotation;
                CurrentVelocityState = VelocityState.Calculating;
            }

            ResetInteraction();
        }
    }

    /// <inheritdoc/>
    void IMixedRealityPointerHandler.OnPointerDown(MixedRealityPointerEventData eventData)
    {
        // Current pointer owns scroll interaction until scroll release happens. Ignoring any interaction with other pointers.
        if (currentPointer != null)
        {
            return;
        }

        var selectedObject = eventData.Pointer.Result?.CurrentPointerTarget;

        if (selectedObject == null || !selectedObject.transform.IsChildOf(transform))
        {
            return;
        }

        currentPointer = eventData.Pointer;
        oldIsTargetPositionLockedOnFocusLock = currentPointer.IsTargetPositionLockedOnFocusLock;

        if (!(currentPointer is IMixedRealityNearPointer) && currentPointer.Controller.IsRotationAvailable)
        {
            currentPointer.IsTargetPositionLockedOnFocusLock = false;
        }

        initialFocusedObject = selectedObject;
        currentPointer.IsFocusLocked = false; // Unwanted focus locked on children items

        // Reset the scroll state
        scrollVelocity = 0.0f;

        if (TryGetPointerPositionOnPlane(out initialPointerPos))
        {
            initialRotation = transform.localEulerAngles;
            CurrentVelocityState = VelocityState.None;

            IsTouched = false;
            IsEngaged = true;
            IsDragging = false;

            OnTouchStarted?.Invoke(initialFocusedObject);
        }
    }

    /// <inheritdoc/>
    /// Pointer Click handled during Update.
    void IMixedRealityPointerHandler.OnPointerClicked(MixedRealityPointerEventData eventData) { }

    /// <inheritdoc/>
    void IMixedRealityPointerHandler.OnPointerDragged(MixedRealityPointerEventData eventData) { }

    #endregion IMixedRealityPointerHandler implementation

    #region IMixedRealityTouchHandler implementation

    /// <inheritdoc/>
    void IMixedRealityTouchHandler.OnTouchStarted(HandTrackingInputEventData eventData)
    {
        // Current pointer owns scroll interaction until scroll release happens. Ignoring any interaction with other pointers.
        if (currentPointer != null)
        {
            Debug.Log("OnTouchStarted currentpointer not null");
            return;
        }

        PokePointer pokePointer = PointerUtils.GetPointer<PokePointer>(eventData.Handedness);

        var selectedObject = pokePointer.Result?.CurrentPointerTarget;
        if (selectedObject == null || !selectedObject.transform.IsChildOf(transform))
        {
            Debug.Log("OnTouchStarted selectedObject is null");
            return;
        }

        if (!HasPassedThroughFrontPlane(pokePointer))
        {
            Debug.Log("OnTouchStarted hasn't passed frontplate");
            return;
        }

        currentPointer = pokePointer;

        StopAllCoroutines();
        CurrentVelocityState = VelocityState.None;
        animateScroller = null;

        if (!IsTouched && !IsEngaged)
        {
            Debug.Log("OnTouchStarted is not touched or engaged");
            initialPointerPos = currentPointer.Position;
            initialFocusedObject = selectedObject;
            initialRotation = transform.localEulerAngles;

            IsTouched = true;
            IsEngaged = true;
            IsDragging = false;

            OnTouchStarted?.Invoke(initialFocusedObject);
        }
    }

    /// <inheritdoc/>
    /// Touch release handled during Update.
    void IMixedRealityTouchHandler.OnTouchCompleted(HandTrackingInputEventData eventData) { }

    /// <inheritdoc/>
    void IMixedRealityTouchHandler.OnTouchUpdated(HandTrackingInputEventData eventData)
    {

        if (currentPointer == null || eventData.SourceId != currentPointer.InputSourceParent.SourceId)
        {
            Debug.Log($"OnTouchUpdated currentPointer is null, {currentPointer}");
            return;
        }

        if (IsDragging)
        {
            Debug.Log("OnTouchUpdated currentPointer is dragging");
            eventData.Use();
        }
    }

    #endregion IMixedRealityTouchHandler implementation

    #region IMixedRealitySourceStateHandler implementation

    void IMixedRealitySourceStateHandler.OnSourceDetected(SourceStateEventData eventData) { }

    void IMixedRealitySourceStateHandler.OnSourceLost(SourceStateEventData eventData)
    {
        if (currentPointer == null || eventData.SourceId != currentPointer.InputSourceParent.SourceId)
        {
            return;
        }

        // We'll consider this a drag release
        if (IsEngaged && animateScroller == null)
        {
            if (IsTouched || IsDragging)
            {
                // Its a drag release
                initialRotation = workingRotation;
            }

            ResetInteraction();

            CurrentVelocityState = VelocityState.Calculating;
        }
    }

    #endregion IMixedRealitySourceStateHandler implementation
}
