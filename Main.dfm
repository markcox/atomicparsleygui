object frmMain: TfrmMain
  Left = 382
  Top = 246
  Width = 831
  Height = 636
  Caption = 'AtomicParsley GUI'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 200
    Top = 0
    Height = 600
  end
  object pnlMain: TPanel
    Left = 203
    Top = 0
    Width = 612
    Height = 600
    Align = alClient
    TabOrder = 0
    object splProcess: TSplitter
      Left = 1
      Top = 468
      Width = 610
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object lsvMain: TListView
      Left = 1
      Top = 106
      Width = 610
      Height = 362
      Align = alClient
      Checkboxes = True
      Columns = <>
      ColumnClick = False
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      SortType = stData
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = lsvMainSelectItem
    end
    object memProcess: TMemo
      Left = 1
      Top = 471
      Width = 610
      Height = 128
      Align = alBottom
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object pctMain: TPageControl
      Left = 1
      Top = 1
      Width = 610
      Height = 105
      ActivePage = tbsTV
      Align = alTop
      TabOrder = 2
      object tbsTV: TTabSheet
        Caption = 'TV Shows'
        object Label1: TLabel
          Left = 16
          Top = 8
          Width = 58
          Height = 13
          Caption = 'Show Name'
        end
        object Label2: TLabel
          Left = 40
          Top = 40
          Width = 36
          Height = 13
          Caption = 'Season'
        end
        object Label3: TLabel
          Left = 135
          Top = 40
          Width = 66
          Height = 13
          Caption = 'First Show No'
        end
        object btnTvProcessFiles: TButton
          Left = 408
          Top = 34
          Width = 89
          Height = 25
          Caption = 'Process Files'
          TabOrder = 3
          OnClick = btnTvProcessFilesClick
        end
        object edtTVShowName: TEdit
          Left = 89
          Top = 4
          Width = 292
          Height = 21
          TabOrder = 0
        end
        object edtTVSeason: TEdit
          Left = 89
          Top = 36
          Width = 30
          Height = 21
          TabOrder = 1
          OnExit = edtPadZero
        end
        object edtTVFirstShowNo: TEdit
          Left = 220
          Top = 36
          Width = 30
          Height = 21
          TabOrder = 2
          OnExit = edtPadZero
        end
        object btnTVApplyInfo: TButton
          Left = 408
          Top = 2
          Width = 183
          Height = 25
          Caption = 'Apply Information to Selected Files'
          TabOrder = 4
          OnClick = btnTVApplyInfoClick
        end
      end
      object tbsMovie: TTabSheet
        Caption = 'Movies'
        ImageIndex = 1
      end
      object tbsMusic: TTabSheet
        Caption = 'Music'
        ImageIndex = 2
      end
    end
  end
  object svwMain: TShellTreeView
    Left = 0
    Top = 0
    Width = 200
    Height = 600
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    Align = alLeft
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 1
    OnChange = svwMainChange
  end
end
