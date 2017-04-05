; 10 SYS2064

*=$0801

        BYTE    $0B, $08, $0A, $00, $9E, $32, $30, $36, $34, $00, $00, $00

*=$0810

START                   SEI                             ; Set Interrupt disabled flag to prevent interrupts
                        JSR Init                        ; Call Init subroutine

@MainLoop               LDX #$FA                        ; LOAD X with Immediate value hex #$FA (250)
                        JSR WaitRasterLine              ; jump to WaitRasterLine subroutine

                        LDA $D011                       ; LOAD A with value of VIC II chip register at address $d011
                        AND #$F7                        ; clear bit #3 of the A for setting 24 row screen 
                        STA $D011                       ; STORE value of A back to $d011 to set 24 row mode

                        LDX #$FC                        ; LOAD X with Immediate value hex #$FC (252)
                        JSR WaitRasterLine              ; jump to WaitRasterLine subroutine

                        LDA $D011                       ; And again we LOAD A with value of VIC II crip register at address $d011
                        ORA #$08                        ; set bit #3 of the A for setting 25 row screen back
                        STA $D011                       ; STORE value of A back to $d011 to set 25 row mode

                        LDA $DC01                       ; Check if space is pressed?
                        AND #$10                        ;
                        BNE @MainLoop                   ; branch back to MainLoop if it wasn't pressed

                        CLI                             ; Clear Interrupt disabled flag to allow interrupts again
                        RTS                             ; return from the program


WaitRasterLine          CPX $D012                       ; Compare X to VIC II chip register value at address $d012
                        BNE WaitRasterLine              ; If value is not equal, let's keep waiting.
                        RTS                             ; Now that value is equal, let's return from this routine

Init                    LDA #$00                        ; LOAD A with Immediate value hex #$00 (0)
                        STA $3FFF                       ; STORE A to last byte of gfx bank to get rid of black...
                        RTS                             ; Return from subroutine