ENTRY(Reset_Handler)
EXTERN(VectorTable)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x2000138C, LENGTH = 300
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 60K
}

_estack = 0x20001388;

SECTIONS
{
    . = 0x0;
    .isr_vectors : 
    {
     . = ALIGN(4);
     KEEP(*(.isr_vectors))
     . = ALIGN(4);
    } >FLASH

    .org_fw_up_to_dfb4 :
    {
      . = ALIGN(4);
      KEEP(*(.org_fw_up_to_dfb4))
    } > FLASH

    /* Add a section 0xc0 bytes long to make the next section start at 0xe074 */
    .extraSection :
    {
      . = ALIGN(4);
      FILL(0);
      KEEP (*(SORT(.init_array.*)))
      KEEP (*(.init_array*))
      . += 0xc0;    /* expand to full size after inserting the code */
    } > FLASH

    .org_fw_rest_from_e074 :
    {
      . = ALIGN(4);
      KEEP(*(.org_fw_rest_from_e074))
    } > FLASH

    /*
    .org_vectors :
    {
      . = ALIGN(4);
      __org_vectors_start = .;
      KEEP(*(.org_vectors))
    } > FLASH
    */
    .text :
    {
        . = ALIGN(4);
        *(.text)   
        *(.text*) 
        *(.rodata)
        *(.rodata*)
        KEEP (*(.init))
        KEEP (*(.fini))
        . = ALIGN(4);
        /* __udivsi3 = __wrap___udivsi3; */

    } >FLASH

    .preinit_array     :
    {
      __preinit_array_start = .;
      KEEP (*(.preinit_array*))
      __preinit_array_end = .;
    } >FLASH
    .fini_array :
    {
      PROVIDE_HIDDEN (__fini_array_start = .);
      KEEP (*(SORT(.fini_array.*)))
      KEEP (*(.fini_array*))
      PROVIDE_HIDDEN (__fini_array_end = .);
      . = ALIGN(4);
      _flash_data_start = .;
    } >FLASH
    
     _sidata = LOADADDR(.data);
    .data : AT (_flash_data_start)
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data*)
        *(.ramsection)
        _edata = .;
    } >RAM

    .bss :
    {
      . = ALIGN(4);
       _sbss = .;
        *(.bss)       
      _ebss = .;
    } >RAM

      /DISCARD/ :
  {
  }    
}