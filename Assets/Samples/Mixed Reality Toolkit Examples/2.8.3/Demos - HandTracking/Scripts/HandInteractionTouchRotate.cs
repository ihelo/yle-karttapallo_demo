// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using Microsoft.MixedReality.Toolkit.Input;
using UnityEngine;
using UnityEngine.Serialization;

namespace Microsoft.MixedReality.Toolkit.Examples.Demos
{
    [AddComponentMenu("Scripts/MRTK/Examples/HandInteractionTouchRotate")]
    public class HandInteractionTouchRotate : HandInteractionTouch, IMixedRealityTouchHandler
    {
        [SerializeField]
        [FormerlySerializedAs("TargetObjectTransform")]
        private Transform targetObjectTransform = null;

        [SerializeField]
        public float rotateSpeed = 10f;
        private bool isTouched;

        ///void Update()
        //{
          //  if (!isTouched)
            //{
              //  targetObjectTransform.Rotate(Vector3.up * (rotateSpeed * Time.deltaTime));
            //}
        //}


        void IMixedRealityTouchHandler.OnTouchStarted(HandTrackingInputEventData eventData)
        {
            isTouched = true;

        }
        void IMixedRealityTouchHandler.OnTouchUpdated(HandTrackingInputEventData eventData)
        {
            if (targetObjectTransform != null)
            {
                isTouched = false;
            }

        }

    }
}