object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Vendas'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Panel1: TPanel
    Left = 24
    Top = 8
    Width = 577
    Height = 393
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 105
      Height = 15
      Caption = 'C'#243'digo do Produto:'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 65
      Height = 15
      Caption = 'Quantidade:'
    end
    object Label3: TLabel
      Left = 231
      Top = 58
      Width = 74
      Height = 15
      Caption = 'Valor Unit'#225'rio:'
    end
    object edtCodProduto: TEdit
      Left = 127
      Top = 21
      Width = 98
      Height = 23
      TabOrder = 0
    end
    object edtQuantidade: TEdit
      Left = 127
      Top = 50
      Width = 66
      Height = 23
      TabOrder = 1
    end
    object edtVlUnitario: TEdit
      Left = 311
      Top = 50
      Width = 75
      Height = 23
      TabOrder = 2
    end
    object btnOk: TButton
      Left = 311
      Top = 79
      Width = 75
      Height = 25
      Caption = 'SALVA'
      ModalResult = 1
      TabOrder = 3
      OnClick = btnOkClick
    end
    object DBGrid1: TDBGrid
      Left = 16
      Top = 128
      Width = 545
      Height = 225
      TabOrder = 4
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnCellClick = DBGrid1CellClick
      OnKeyDown = DBGrid1KeyDown
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 372
      Width = 575
      Height = 20
      Panels = <>
      ExplicitWidth = 200
    end
    object btnGravarPedido: TButton
      Left = 479
      Top = 97
      Width = 82
      Height = 25
      Caption = 'Gravar Pedido'
      TabOrder = 6
      OnClick = btnGravarPedidoClick
    end
  end
  object dtsObtemProdutos: TDataSource
    Left = 528
    Top = 336
  end
end
