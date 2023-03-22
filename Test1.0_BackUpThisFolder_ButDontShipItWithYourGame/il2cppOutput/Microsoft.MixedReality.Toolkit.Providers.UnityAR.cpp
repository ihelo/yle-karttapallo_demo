#include "pch-cpp.hpp"

#ifndef _MSC_VER
# include <alloca.h>
#else
# include <malloc.h>
#endif


#include <limits>
#include <stdint.h>


template <typename R>
struct VirtualFuncInvoker0
{
	typedef R (*Func)(void*, const RuntimeMethod*);

	static inline R Invoke (Il2CppMethodSlot slot, RuntimeObject* obj)
	{
		const VirtualInvokeData& invokeData = il2cpp_codegen_get_virtual_invoke_data(slot, obj);
		return ((Func)invokeData.methodPtr)(obj, invokeData.method);
	}
};

// System.String[]
struct StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248;
// Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProfile
struct BaseCameraSettingsProfile_tDB8373232611B34628752DF4D284B938CFE32799;
// Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProvider
struct BaseCameraSettingsProvider_tD700E49A18844AC7B08C84247430319CFEC93F46;
// Microsoft.MixedReality.Toolkit.BaseMixedRealityProfile
struct BaseMixedRealityProfile_tB4FDEF58FFD17796C0DB7241630B71CDF38FA1D4;
// Microsoft.MixedReality.Toolkit.CameraSystem.IMixedRealityCameraSystem
struct IMixedRealityCameraSystem_tCB1C695B973C92DD68D0B561E01683EFFAE9044C;
// Microsoft.MixedReality.Toolkit.IMixedRealityServiceRegistrar
struct IMixedRealityServiceRegistrar_t4B893B7CDAAC977211D826D02C8522ECA327D715;
// UnityEngine.Object
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C;
// System.String
struct String_t;
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings
struct UnityARCameraSettings_tEE96490B50567703BEFDD8FF113C55A76CC58CA9;
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile
struct UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3;
// System.Void
struct Void_t4861ACF8F4594C3437BB48B6E56783494B843915;

IL2CPP_EXTERN_C RuntimeClass* Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C RuntimeClass* UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3_il2cpp_TypeInfo_var;
IL2CPP_EXTERN_C String_t* _stringLiteral6798986EE6D13B043A77AFD8D1CABA0C685A8E8C;


IL2CPP_EXTERN_C_BEGIN
IL2CPP_EXTERN_C_END

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif

// <Module>
struct U3CModuleU3E_tC2D3FDBE912C450C40126F8E1F3FE97D7E530227 
{
};

// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArEnumConversion
struct ArEnumConversion_tB723C0A4C1FF7726A6699AC3A5D787F1EAA21BC9  : public RuntimeObject
{
};
struct Il2CppArrayBounds;

// System.String
struct String_t  : public RuntimeObject
{
	// System.Int32 System.String::_stringLength
	int32_t ____stringLength_4;
	// System.Char System.String::_firstChar
	Il2CppChar ____firstChar_5;
};

struct String_t_StaticFields
{
	// System.String System.String::Empty
	String_t* ___Empty_6;
};

// System.ValueType
struct ValueType_t6D9B272BD21782F0A9A14F2E41F85A50E97A986F  : public RuntimeObject
{
};
// Native definition for P/Invoke marshalling of System.ValueType
struct ValueType_t6D9B272BD21782F0A9A14F2E41F85A50E97A986F_marshaled_pinvoke
{
};
// Native definition for COM marshalling of System.ValueType
struct ValueType_t6D9B272BD21782F0A9A14F2E41F85A50E97A986F_marshaled_com
{
};

// System.Nullable`1<System.Boolean>
struct Nullable_1_t78F453FADB4A9F50F267A4E349019C34410D1A01 
{
	// System.Boolean System.Nullable`1::hasValue
	bool ___hasValue_0;
	// T System.Nullable`1::value
	bool ___value_1;
};

// System.Boolean
struct Boolean_t09A6377A54BE2F9E6985A8149F19234FD7DDFE22 
{
	// System.Boolean System.Boolean::m_value
	bool ___m_value_0;
};

struct Boolean_t09A6377A54BE2F9E6985A8149F19234FD7DDFE22_StaticFields
{
	// System.String System.Boolean::TrueString
	String_t* ___TrueString_5;
	// System.String System.Boolean::FalseString
	String_t* ___FalseString_6;
};

// System.IntPtr
struct IntPtr_t 
{
	// System.Void* System.IntPtr::m_value
	void* ___m_value_0;
};

struct IntPtr_t_StaticFields
{
	// System.IntPtr System.IntPtr::Zero
	intptr_t ___Zero_1;
};

// System.UInt32
struct UInt32_t1833D51FFA667B18A5AA4B8D34DE284F8495D29B 
{
	// System.UInt32 System.UInt32::m_value
	uint32_t ___m_value_0;
};

// System.Void
struct Void_t4861ACF8F4594C3437BB48B6E56783494B843915 
{
	union
	{
		struct
		{
		};
		uint8_t Void_t4861ACF8F4594C3437BB48B6E56783494B843915__padding[1];
	};
};

// Microsoft.MixedReality.Toolkit.BaseService
struct BaseService_tB7EC5C0F60DC5EE2DA122A608226D3887B6421D0  : public RuntimeObject
{
	// System.String Microsoft.MixedReality.Toolkit.BaseService::<Name>k__BackingField
	String_t* ___U3CNameU3Ek__BackingField_1;
	// System.UInt32 Microsoft.MixedReality.Toolkit.BaseService::<Priority>k__BackingField
	uint32_t ___U3CPriorityU3Ek__BackingField_2;
	// Microsoft.MixedReality.Toolkit.BaseMixedRealityProfile Microsoft.MixedReality.Toolkit.BaseService::<ConfigurationProfile>k__BackingField
	BaseMixedRealityProfile_tB4FDEF58FFD17796C0DB7241630B71CDF38FA1D4* ___U3CConfigurationProfileU3Ek__BackingField_3;
	// System.Nullable`1<System.Boolean> Microsoft.MixedReality.Toolkit.BaseService::isInitialized
	Nullable_1_t78F453FADB4A9F50F267A4E349019C34410D1A01 ___isInitialized_4;
	// System.String[] Microsoft.MixedReality.Toolkit.BaseService::typeName
	StringU5BU5D_t7674CD946EC0CE7B3AE0BE70E6EE85F2ECD9F248* ___typeName_5;
	// System.Nullable`1<System.Boolean> Microsoft.MixedReality.Toolkit.BaseService::isEnabled
	Nullable_1_t78F453FADB4A9F50F267A4E349019C34410D1A01 ___isEnabled_9;
	// System.Nullable`1<System.Boolean> Microsoft.MixedReality.Toolkit.BaseService::isMarkedDestroyed
	Nullable_1_t78F453FADB4A9F50F267A4E349019C34410D1A01 ___isMarkedDestroyed_10;
	// System.Boolean Microsoft.MixedReality.Toolkit.BaseService::disposed
	bool ___disposed_11;
};

// UnityEngine.Object
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C  : public RuntimeObject
{
	// System.IntPtr UnityEngine.Object::m_CachedPtr
	intptr_t ___m_CachedPtr_0;
};

struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_StaticFields
{
	// System.Int32 UnityEngine.Object::OffsetOfInstanceIDInCPlusPlusObject
	int32_t ___OffsetOfInstanceIDInCPlusPlusObject_1;
};
// Native definition for P/Invoke marshalling of UnityEngine.Object
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_marshaled_pinvoke
{
	intptr_t ___m_CachedPtr_0;
};
// Native definition for COM marshalling of UnityEngine.Object
struct Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_marshaled_com
{
	intptr_t ___m_CachedPtr_0;
};

// Microsoft.MixedReality.Toolkit.BaseDataProvider`1<Microsoft.MixedReality.Toolkit.CameraSystem.IMixedRealityCameraSystem>
struct BaseDataProvider_1_t5511AC264C914065B4C84ECA02C3FC05D1C915B6  : public BaseService_tB7EC5C0F60DC5EE2DA122A608226D3887B6421D0
{
	// Microsoft.MixedReality.Toolkit.IMixedRealityServiceRegistrar Microsoft.MixedReality.Toolkit.BaseDataProvider`1::<Registrar>k__BackingField
	RuntimeObject* ___U3CRegistrarU3Ek__BackingField_12;
	// T Microsoft.MixedReality.Toolkit.BaseDataProvider`1::<Service>k__BackingField
	RuntimeObject* ___U3CServiceU3Ek__BackingField_13;
};

// UnityEngine.ScriptableObject
struct ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A  : public Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C
{
};
// Native definition for P/Invoke marshalling of UnityEngine.ScriptableObject
struct ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A_marshaled_pinvoke : public Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_marshaled_pinvoke
{
};
// Native definition for COM marshalling of UnityEngine.ScriptableObject
struct ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A_marshaled_com : public Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_marshaled_com
{
};

// Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProvider
struct BaseCameraSettingsProvider_tD700E49A18844AC7B08C84247430319CFEC93F46  : public BaseDataProvider_1_t5511AC264C914065B4C84ECA02C3FC05D1C915B6
{
	// System.Boolean Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProvider::<IsOpaque>k__BackingField
	bool ___U3CIsOpaqueU3Ek__BackingField_14;
};

// Microsoft.MixedReality.Toolkit.BaseMixedRealityProfile
struct BaseMixedRealityProfile_tB4FDEF58FFD17796C0DB7241630B71CDF38FA1D4  : public ScriptableObject_tB3BFDB921A1B1795B38A5417D3B97A89A140436A
{
	// System.Boolean Microsoft.MixedReality.Toolkit.BaseMixedRealityProfile::isCustomProfile
	bool ___isCustomProfile_4;
};

// Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProfile
struct BaseCameraSettingsProfile_tDB8373232611B34628752DF4D284B938CFE32799  : public BaseMixedRealityProfile_tB4FDEF58FFD17796C0DB7241630B71CDF38FA1D4
{
};

// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings
struct UnityARCameraSettings_tEE96490B50567703BEFDD8FF113C55A76CC58CA9  : public BaseCameraSettingsProvider_tD700E49A18844AC7B08C84247430319CFEC93F46
{
	// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArTrackedPose Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::poseSource
	int32_t ___poseSource_15;
	// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArTrackingType Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::trackingType
	int32_t ___trackingType_16;
	// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArUpdateType Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::updateType
	int32_t ___updateType_17;
};

// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile
struct UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3  : public BaseCameraSettingsProfile_tDB8373232611B34628752DF4D284B938CFE32799
{
	// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArTrackedPose Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::poseSource
	int32_t ___poseSource_5;
	// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArTrackingType Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::trackingType
	int32_t ___trackingType_6;
	// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArUpdateType Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::updateType
	int32_t ___updateType_7;
};
#ifdef __clang__
#pragma clang diagnostic pop
#endif



// System.Void Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProvider::.ctor(Microsoft.MixedReality.Toolkit.CameraSystem.IMixedRealityCameraSystem,System.String,System.UInt32,Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProfile)
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void BaseCameraSettingsProvider__ctor_mAFEF8A563BC57786947687B6BEF2F047EE81F8C8 (BaseCameraSettingsProvider_tD700E49A18844AC7B08C84247430319CFEC93F46* __this, RuntimeObject* ___cameraSystem0, String_t* ___name1, uint32_t ___priority2, BaseCameraSettingsProfile_tDB8373232611B34628752DF4D284B938CFE32799* ___profile3, const RuntimeMethod* method) ;
// System.Void Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::ReadProfile()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void UnityARCameraSettings_ReadProfile_m02290EC65B3EF631E42195D779694D34AE785BB3 (UnityARCameraSettings_tEE96490B50567703BEFDD8FF113C55A76CC58CA9* __this, const RuntimeMethod* method) ;
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::get_SettingsProfile()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* UnityARCameraSettings_get_SettingsProfile_m52A51ED6AC70FE5FF0025D88224A46CAAB0822B4 (UnityARCameraSettings_tEE96490B50567703BEFDD8FF113C55A76CC58CA9* __this, const RuntimeMethod* method) ;
// System.Boolean UnityEngine.Object::op_Equality(UnityEngine.Object,UnityEngine.Object)
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605 (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* ___x0, Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C* ___y1, const RuntimeMethod* method) ;
// System.Void UnityEngine.Debug::LogWarning(System.Object)
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void Debug_LogWarning_m33EF1B897E0C7C6FF538989610BFAFFEF4628CA9 (RuntimeObject* ___message0, const RuntimeMethod* method) ;
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArTrackedPose Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::get_PoseSource()
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_PoseSource_m4E461938D0D9A31FAA244B90E5EE60D08818DA50_inline (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) ;
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArTrackingType Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::get_TrackingType()
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_TrackingType_mF344A20835D8987D73DFE8528076B2087495840F_inline (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) ;
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArUpdateType Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::get_UpdateType()
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_UpdateType_m11C9BC522B7936D704FB6B3D869F39AA9984D0C7_inline (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) ;
// System.Void Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProfile::.ctor()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void BaseCameraSettingsProfile__ctor_m1A7C4C1E005080B92C890C41B6130A70836E0EE8 (BaseCameraSettingsProfile_tDB8373232611B34628752DF4D284B938CFE32799* __this, const RuntimeMethod* method) ;
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
// System.Void Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::.ctor(Microsoft.MixedReality.Toolkit.CameraSystem.IMixedRealityCameraSystem,System.String,System.UInt32,Microsoft.MixedReality.Toolkit.CameraSystem.BaseCameraSettingsProfile)
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void UnityARCameraSettings__ctor_m89E5E5C27130BEF64D68760EF2977884FA60B7FC (UnityARCameraSettings_tEE96490B50567703BEFDD8FF113C55A76CC58CA9* __this, RuntimeObject* ___cameraSystem0, String_t* ___name1, uint32_t ___priority2, BaseCameraSettingsProfile_tDB8373232611B34628752DF4D284B938CFE32799* ___profile3, const RuntimeMethod* method) 
{
	{
		// private ArTrackedPose poseSource = ArTrackedPose.ColorCamera;
		__this->___poseSource_15 = 6;
		// BaseCameraSettingsProfile profile = null) : base(cameraSystem, name, priority, profile)
		RuntimeObject* L_0 = ___cameraSystem0;
		String_t* L_1 = ___name1;
		uint32_t L_2 = ___priority2;
		BaseCameraSettingsProfile_tDB8373232611B34628752DF4D284B938CFE32799* L_3 = ___profile3;
		BaseCameraSettingsProvider__ctor_mAFEF8A563BC57786947687B6BEF2F047EE81F8C8(__this, L_0, L_1, L_2, L_3, NULL);
		// ReadProfile();
		UnityARCameraSettings_ReadProfile_m02290EC65B3EF631E42195D779694D34AE785BB3(__this, NULL);
		// }
		return;
	}
}
// System.Void Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::ReadProfile()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void UnityARCameraSettings_ReadProfile_m02290EC65B3EF631E42195D779694D34AE785BB3 (UnityARCameraSettings_tEE96490B50567703BEFDD8FF113C55A76CC58CA9* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&_stringLiteral6798986EE6D13B043A77AFD8D1CABA0C685A8E8C);
		s_Il2CppMethodInitialized = true;
	}
	{
		// if (SettingsProfile == null)
		UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* L_0;
		L_0 = UnityARCameraSettings_get_SettingsProfile_m52A51ED6AC70FE5FF0025D88224A46CAAB0822B4(__this, NULL);
		il2cpp_codegen_runtime_class_init_inline(Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C_il2cpp_TypeInfo_var);
		bool L_1;
		L_1 = Object_op_Equality_mB6120F782D83091EF56A198FCEBCF066DB4A9605(L_0, (Object_tC12DECB6760A7F2CBF65D9DCF18D044C2D97152C*)NULL, NULL);
		if (!L_1)
		{
			goto IL_0019;
		}
	}
	{
		// Debug.LogWarning("A profile was not specified for the Unity AR Camera Settings provider.\nUsing Microsoft Mixed Reality Toolkit default options.");
		il2cpp_codegen_runtime_class_init_inline(Debug_t8394C7EEAECA3689C2C9B9DE9C7166D73596276F_il2cpp_TypeInfo_var);
		Debug_LogWarning_m33EF1B897E0C7C6FF538989610BFAFFEF4628CA9(_stringLiteral6798986EE6D13B043A77AFD8D1CABA0C685A8E8C, NULL);
		// return;
		return;
	}

IL_0019:
	{
		// poseSource = SettingsProfile.PoseSource;
		UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* L_2;
		L_2 = UnityARCameraSettings_get_SettingsProfile_m52A51ED6AC70FE5FF0025D88224A46CAAB0822B4(__this, NULL);
		NullCheck(L_2);
		int32_t L_3;
		L_3 = UnityARCameraSettingsProfile_get_PoseSource_m4E461938D0D9A31FAA244B90E5EE60D08818DA50_inline(L_2, NULL);
		__this->___poseSource_15 = L_3;
		// trackingType = SettingsProfile.TrackingType;
		UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* L_4;
		L_4 = UnityARCameraSettings_get_SettingsProfile_m52A51ED6AC70FE5FF0025D88224A46CAAB0822B4(__this, NULL);
		NullCheck(L_4);
		int32_t L_5;
		L_5 = UnityARCameraSettingsProfile_get_TrackingType_mF344A20835D8987D73DFE8528076B2087495840F_inline(L_4, NULL);
		__this->___trackingType_16 = L_5;
		// updateType = SettingsProfile.UpdateType;
		UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* L_6;
		L_6 = UnityARCameraSettings_get_SettingsProfile_m52A51ED6AC70FE5FF0025D88224A46CAAB0822B4(__this, NULL);
		NullCheck(L_6);
		int32_t L_7;
		L_7 = UnityARCameraSettingsProfile_get_UpdateType_m11C9BC522B7936D704FB6B3D869F39AA9984D0C7_inline(L_6, NULL);
		__this->___updateType_17 = L_7;
		// }
		return;
	}
}
// System.Boolean Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::get_IsOpaque()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR bool UnityARCameraSettings_get_IsOpaque_m8B3955D346F13A6BA6FCD572C9F4C788FA8A8B07 (UnityARCameraSettings_tEE96490B50567703BEFDD8FF113C55A76CC58CA9* __this, const RuntimeMethod* method) 
{
	{
		// public override bool IsOpaque => poseSource != ArTrackedPose.ColorCamera;
		int32_t L_0 = __this->___poseSource_15;
		return (bool)((((int32_t)((((int32_t)L_0) == ((int32_t)6))? 1 : 0)) == ((int32_t)0))? 1 : 0);
	}
}
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettings::get_SettingsProfile()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* UnityARCameraSettings_get_SettingsProfile_m52A51ED6AC70FE5FF0025D88224A46CAAB0822B4 (UnityARCameraSettings_tEE96490B50567703BEFDD8FF113C55A76CC58CA9* __this, const RuntimeMethod* method) 
{
	static bool s_Il2CppMethodInitialized;
	if (!s_Il2CppMethodInitialized)
	{
		il2cpp_codegen_initialize_runtime_metadata((uintptr_t*)&UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3_il2cpp_TypeInfo_var);
		s_Il2CppMethodInitialized = true;
	}
	{
		// public UnityARCameraSettingsProfile SettingsProfile => ConfigurationProfile as UnityARCameraSettingsProfile;
		BaseMixedRealityProfile_tB4FDEF58FFD17796C0DB7241630B71CDF38FA1D4* L_0;
		L_0 = VirtualFuncInvoker0< BaseMixedRealityProfile_tB4FDEF58FFD17796C0DB7241630B71CDF38FA1D4* >::Invoke(22 /* Microsoft.MixedReality.Toolkit.BaseMixedRealityProfile Microsoft.MixedReality.Toolkit.BaseService::get_ConfigurationProfile() */, __this);
		return ((UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3*)IsInstClass((RuntimeObject*)L_0, UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3_il2cpp_TypeInfo_var));
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArTrackedPose Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::get_PoseSource()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_PoseSource_m4E461938D0D9A31FAA244B90E5EE60D08818DA50 (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) 
{
	{
		// public ArTrackedPose PoseSource => poseSource;
		int32_t L_0 = __this->___poseSource_5;
		return L_0;
	}
}
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArTrackingType Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::get_TrackingType()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_TrackingType_mF344A20835D8987D73DFE8528076B2087495840F (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) 
{
	{
		// public ArTrackingType TrackingType => trackingType;
		int32_t L_0 = __this->___trackingType_6;
		return L_0;
	}
}
// Microsoft.MixedReality.Toolkit.Experimental.UnityAR.ArUpdateType Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::get_UpdateType()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_UpdateType_m11C9BC522B7936D704FB6B3D869F39AA9984D0C7 (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) 
{
	{
		// public ArUpdateType UpdateType => updateType;
		int32_t L_0 = __this->___updateType_7;
		return L_0;
	}
}
// System.Void Microsoft.MixedReality.Toolkit.Experimental.UnityAR.UnityARCameraSettingsProfile::.ctor()
IL2CPP_EXTERN_C IL2CPP_METHOD_ATTR void UnityARCameraSettingsProfile__ctor_m32BE805604894831A69E8D0F193905EEC3AD9D8A (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) 
{
	{
		// private ArTrackedPose poseSource = ArTrackedPose.ColorCamera;
		__this->___poseSource_5 = 6;
		BaseCameraSettingsProfile__ctor_m1A7C4C1E005080B92C890C41B6130A70836E0EE8(__this, NULL);
		return;
	}
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif
#ifdef __clang__
#pragma clang diagnostic pop
#endif
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_PoseSource_m4E461938D0D9A31FAA244B90E5EE60D08818DA50_inline (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) 
{
	{
		// public ArTrackedPose PoseSource => poseSource;
		int32_t L_0 = __this->___poseSource_5;
		return L_0;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_TrackingType_mF344A20835D8987D73DFE8528076B2087495840F_inline (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) 
{
	{
		// public ArTrackingType TrackingType => trackingType;
		int32_t L_0 = __this->___trackingType_6;
		return L_0;
	}
}
IL2CPP_MANAGED_FORCE_INLINE IL2CPP_METHOD_ATTR int32_t UnityARCameraSettingsProfile_get_UpdateType_m11C9BC522B7936D704FB6B3D869F39AA9984D0C7_inline (UnityARCameraSettingsProfile_t97681668F15F49FB481014F0668E5E9CFAE523D3* __this, const RuntimeMethod* method) 
{
	{
		// public ArUpdateType UpdateType => updateType;
		int32_t L_0 = __this->___updateType_7;
		return L_0;
	}
}
