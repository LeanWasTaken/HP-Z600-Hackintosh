//
// Supplementary HPET _CRS from Goldfish64
// Requires the HPET's _CRS to XCRS rename
//
DefinitionBlock ("", "SSDT", 2, "CORP", "HPET", 0x00000000)
{
    External (\_SB.PCI0.LPC.HPET, DeviceObj)
    External (\_SB.PCI0.LPC.HPET.XCRS, MethodObj)
    External (\_SB.PCI0.LPC.HPET.XSTA, MethodObj)

    Scope (\_SB.PCI0.LPC.HPET)
    {
        Name (BUFX, ResourceTemplate ()
        {
            IRQNoFlags ()
                {0,8,11}
            Memory32Fixed (ReadWrite,
                // Base/Length pulled from DSDT
                0x00000000,         // Address Base
                0x00000000,         // Address Length
            )
        })
        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            // Return our buffer if booting macOS or the XCRS method
            // no longer exists for some reason
            If (LOr (_OSI ("Darwin"), LNot(CondRefOf (\_SB.PCI0.LPC.HPET.XCRS))))
            {
                Return (BUFX)
            }
            // Not macOS and XCRS exists - return its result
            Return (\_SB.PCI0.LPC.HPET.XCRS ())
        }
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            // Return 0x0F if booting macOS or the XSTA method
            // no longer exists for some reason
            If (LOr (_OSI ("Darwin"), LNot (CondRefOf (\_SB.PCI0.LPC.HPET.XSTA))))
            {
                Return (0x0F)
            }
            // Not macOS and XSTA exists - return its result
            Return (\_SB.PCI0.LPC.HPET.XSTA ())
        }
    }
}