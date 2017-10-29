.486                        ; force 32 bit code
.model flat, stdcall        ; memory model & calling convention
option casemap :none        ; case sensitive

include windows.inc

include user32.inc
includelib user32.lib

include TreeView.inc

.code

;**************************************************************************
; 
;**************************************************************************
TreeViewSetItemImage PROC PUBLIC hTreeview:DWORD, hItem:DWORD, nImageListIndex:DWORD
    LOCAL TVI:TV_ITEM
    mov TVI._mask, TVIF_IMAGE ;or TVIF_SELECTEDIMAGE	
    mov eax, hItem
    mov TVI.hItem, eax
    mov eax, nImageListIndex
    mov TVI.iImage, eax
    Invoke SendMessage, hTreeview, TVM_SETITEM, 0, Addr TVI
    ret
TreeViewSetItemImage ENDP

end