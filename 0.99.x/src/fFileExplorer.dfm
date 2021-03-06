object fmExplorer: TfmExplorer
  Left = 494
  Top = 213
  Align = alClient
  BorderStyle = bsNone
  Caption = 'fmExplorer'
  ClientHeight = 460
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnDir: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 17
    Align = alTop
    BevelOuter = bvNone
    FullRepaint = False
    ParentBackground = False
    TabOrder = 0
    object labDir: TLabel
      Left = 0
      Top = 0
      Width = 297
      Height = 13
      Align = alTop
      Caption = 'labDir'
      ParentShowHint = False
      ShowHint = True
      ExplicitWidth = 27
    end
  end
  object TBXDock1: TSpTBXDock
    Left = 0
    Top = 17
    Width = 297
    Height = 26
    AllowDrag = False
    object tbFileExplorer: TSpTBXToolbar
      Left = 0
      Top = 0
      DockPos = 0
      FullSize = True
      Images = fmMain.ilToolbar
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'tbFileExplorer'
      object TBXItem2: TSpTBXItem
        Action = acFileTree
      end
      object TBXItem1: TSpTBXItem
        Caption = 'acLevelUp'
        Action = acLevelUp
      end
      object TBXItem10: TSpTBXItem
        Action = fmMain.acFileChangeToFileDir
      end
      object TBXSeparatorItem1: TSpTBXSeparatorItem
      end
      object TBXItem4: TSpTBXItem
        Action = acOpen
      end
      object TBXSeparatorItem2: TSpTBXSeparatorItem
      end
      object miFilter: TSpTBXSubmenuItem
        Caption = 'acFilter'
        Action = acFilter
        Options = [tboDropdownArrow]
        LinkSubitems = TBXSubmenuItem5
      end
    end
  end
  object lv: TVirtualExplorerListview
    Left = 0
    Top = 43
    Width = 297
    Height = 417
    Active = True
    Align = alClient
    ColumnDetails = cdShellColumns
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    FileObjects = [foFolders, foNonFolders, foHidden]
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = -1
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Shell Dlg 2'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDblClickResize, hoShowSortGlyphs, hoVisible]
    Header.SortColumn = 0
    HintMode = hmHint
    Indent = 0
    ParentColor = False
    ParentShowHint = False
    PopupMenu = TBXPopupMenu1
    RootFolder = rfCustom
    RootFolderCustomPath = 'c:\'
    ShowHint = True
    TabOrder = 2
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll]
    TreeOptions.MiscOptions = [toEditable, toReportMode, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowTreeLines, toThemeAware, toUseBlendedImages, toGhostedIfUnfocused]
    TreeOptions.SelectionOptions = [toMiddleClickSelect, toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETFolderOptions = [toHideRootFolder, toForceHideRecycleBin]
    TreeOptions.VETShellOptions = [toRightAlignSizeColumn]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toNoRebuildIconListOnAssocChange, toRightButtonSelect]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
    OnContextMenuAfterCmd = lvContextMenuAfterCmd
    OnContextMenuCmd = lvContextMenuCmd
    OnDblClick = acOpenExecute
    OnDragOver = lvDragOver
    OnEnumFolder = lvEnumFolder
    OnRootChange = lvRootChange
    OnStartDrag = lvStartDrag
    ColumnMenuItemCount = 8
  end
  object alExpl: TActionList
    Images = fmMain.ilToolbar
    OnUpdate = alExplUpdate
    Left = 244
    Top = 72
    object acLevelUp: TAction
      ImageIndex = 22
      ShortCut = 8
      OnExecute = acLevelUpExecute
    end
    object acFilter: TAction
      ImageIndex = 23
      OnExecute = acFilterExecute
    end
    object acOpen: TAction
      Caption = 'acOpen'
      ImageIndex = 1
      ShortCut = 13
      OnExecute = acOpenExecute
    end
    object acFileTree: TAction
      Caption = 'acFileTree'
      ImageIndex = 25
      OnExecute = acFileTreeExecute
    end
  end
  object TBXPopupMenu1: TSpTBXPopupMenu
    Images = fmMain.ilToolbar
    Left = 244
    Top = 136
    object TBXItem9: TSpTBXItem
      Action = acOpen
      FontSettings.Style = [fsBold]
    end
    object TBXItem3: TSpTBXItem
      Action = acLevelUp
    end
    object TBXSeparatorItem3: TSpTBXSeparatorItem
    end
    object TBXSubmenuItem6: TSpTBXSubmenuItem
      Action = acFilter
      LinkSubitems = TBXSubmenuItem5
    end
  end
  object TBItemContainer2: TTBItemContainer
    Left = 244
    Top = 200
    object TBXSubmenuItem5: TSpTBXSubmenuItem
      object labActiveFilter: TSpTBXLabelItem
      end
      object TBXSeparatorItem4: TSpTBXSeparatorItem
      end
    end
  end
end
