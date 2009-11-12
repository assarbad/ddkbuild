// $Id$

#ifdef DDKBUILD_WDM
#   include <wdm.h>
#else
#   include <ntddk.h>
#endif // DDKBUILD_WDM

NTSTATUS DriverEntry(
    IN OUT PDRIVER_OBJECT   DriverObject,
    IN PUNICODE_STRING      RegistryPath
    )
{
    return STATUS_ACCESS_DENIED;
}
