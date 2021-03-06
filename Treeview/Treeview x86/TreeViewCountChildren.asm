.486                        ; force 32 bit code
.model flat, stdcall        ; memory model & calling convention
option casemap :none        ; case sensitive

include windows.inc

include user32.inc
includelib user32.lib

include TreeView.inc


.code

;**************************************************************************
; TreeViewCountChildren - count child items under current item,
; if bRecurse is TRUE then it will count all grandchildren etc as well
;**************************************************************************
TreeViewCountChildren PROC PUBLIC USES EBX hTreeview:DWORD, hItem:DWORD, bRecurse:DWORD
    LOCAL hCurrentItem:DWORD
    LOCAL dwChildrenCount:DWORD
    
    mov dwChildrenCount, 0
    
    .IF hItem == NULL
        Invoke TreeViewGetSelectedItem, hTreeview
    .ELSE
        mov eax, hItem
    .ENDIF
    mov hCurrentItem, eax
    
    Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_CHILD, hCurrentItem
    .WHILE eax != NULL
        mov hCurrentItem, eax
        inc dwChildrenCount
        .IF bRecurse == TRUE
            Invoke TreeViewCountChildren, hTreeview, hCurrentItem, bRecurse
            mov ebx, dwChildrenCount
            add eax, ebx
            mov dwChildrenCount, eax
        .ENDIF
        Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_NEXT, hCurrentItem
    .ENDW
    mov eax, dwChildrenCount
    ret

TreeViewCountChildren ENDP


;int CountTreeItems(CTreeCtrl *pTree, HTREEITEM hItem = NULL, BOOL Recurse = TRUE)
;{
;	int Count = 0;
;	if (hItem == NULL)
;		hItem = pTree->GetSelectedItem();
;	if (pTree->ItemHasChildren(hItem))
;	{
;		hItem = pTree->GetNextItem(hItem, TVGN_CHILD);
;		while (hItem)
;		{
;			Count++;
;			if (Recurse)
;				Count += CountTreeItems(pTree, hItem, Recurse);
;			hItem = pTree->GetNextItem(hItem, TVGN_NEXT);
;		}
;	}
;	return Count;
;}


end