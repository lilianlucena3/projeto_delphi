unit vendas;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, DataModule, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtCodProduto: TEdit;
    Label2: TLabel;
    edtQuantidade: TEdit;
    Label3: TLabel;
    edtVlUnitario: TEdit;
    Label4: TLabel; // Novo Label para Descri��o
    edtDescricao: TEdit; // Novo Edit para Descri��o
    Label5: TLabel; // Novo Label para Pre�o de Venda
    edtPrecVenda: TEdit; // Novo Edit para Pre�o de Venda
    btnOk: TButton;
    DBGrid1: TDBGrid;
    dtsObtemProdutos: TDataSource;
    StatusBar1: TStatusBar;
    btnGravarPedido: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregarCampos;
    procedure AtualizarProduto;
    procedure SalvarProduto;
    procedure AtualizarTotalPedidos;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Carregar os produtos ao iniciar o formul�rio
  DataModule1.CarregarProdutos;
  dtsObtemProdutos.DataSet := DataModule1.FDQueryProdutos;
  DBGrid1.DataSource := dtsObtemProdutos;

  // Configurar o formul�rio para capturar eventos de tecla
  KeyPreview := True; // Permite que o formul�rio capture eventos de tecla

  // Atualizar o total dos pedidos
  AtualizarTotalPedidos;
end;

procedure TForm1.btnGravarPedidoClick(Sender: TObject);
var
  NumPedido: Integer;
  DtEmissao: TDateTime;
  CodCliente: Integer;
  VlTotal: Currency;
  CodProduto: Integer;
  Quantidade: Integer;
  VlUnitario: Currency;
begin
  try
    // Obter dados dos campos
    NumPedido := StrToInt(edtNumPedido.Text);
    DtEmissao := edtDtEmissao.DateTime;
    CodCliente := StrToInt(edtCodCliente.Text);
    VlTotal := StrToCurr(edtVlTotal.Text);
    CodProduto := StrToInt(edtCodProduto.Text);
    Quantidade := StrToInt(edtQuantidade.Text);
    VlUnitario := StrToCurr(edtVlUnitario.Text);

    // Chama o m�todo para gravar o pedido
    DataModule1.GravarPedido(NumPedido, DtEmissao, CodCliente, VlTotal, CodProduto, Quantidade, VlUnitario);

    // Atualizar o grid
    DataModule1.CarregarProdutos;

    // Atualizar o total dos pedidos
    AtualizarTotalPedidos;

    // Exibir mensagem de sucesso
    ShowMessage('Pedido gravado com sucesso.');

    // Limpar os campos ap�s salvar
    edtNumPedido.Text := '';
    edtCodCliente.Text := '';
    edtVlTotal.Text := '';
    edtCodProduto.Text := '';
    edtQuantidade.Text := '';
    edtVlUnitario.Text := '';
  except
    on E: Exception do
      ShowMessage('Erro ao gravar o pedido: ' + E.Message);
  end;
end;

procedure TForm1.btnOkClick(Sender: TObject);
begin
  SalvarProduto;
end;

procedure TForm1.CarregarCampos;
begin
  // Carregar os valores do registro selecionado para os campos de edi��o
  edtCodProduto.Text := DataModule1.FDQueryProdutos.FieldByName('codigo').AsString;
  edtQuantidade.Text := DataModule1.FDQueryProdutos.FieldByName('quantidade').AsString;
  edtVlUnitario.Text := DataModule1.FDQueryProdutos.FieldByName('vlUnitario').AsString;
  edtDescricao.Text := DataModule1.FDQueryProdutos.FieldByName('descricao').AsString;
  edtPrecVenda.Text := DataModule1.FDQueryProdutos.FieldByName('precVenda').AsString;
end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
begin
   CarregarCampos;
end;

procedure TForm1.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     // Verifica se a tecla pressionada � ENTER
  if Key = VK_RETURN then
  begin
    AtualizarProduto;
    Key := 0; // Impede o processamento adicional da tecla ENTER
  end;
end;

procedure TForm1.AtualizarProduto;
var
  Codigo: Integer;
  ValorUnitario: Currency;
  Quantidade: Integer;
  Descricao: string;
  PrecoVenda: Currency;
begin
  try
    // Obter dados dos campos
    Codigo := StrToInt(edtCodProduto.Text);
    ValorUnitario := StrToCurr(edtVlUnitario.Text);
    Quantidade := StrToInt(edtQuantidade.Text);
    Descricao := edtDescricao.Text;
    PrecoVenda := StrToCurr(edtPrecVenda.Text);

    // Chama o m�todo para atualizar o produto
    DataModule1.InserirOuRemoverProduto('I', Codigo, Quantidade, ValorUnitario, Descricao, PrecoVenda);

    // Atualizar o grid
    DataModule1.CarregarProdutos;

    // Exibir mensagem de sucesso
    ShowMessage('Produto atualizado com sucesso.');

    // Limpar os campos ap�s salvar
    edtCodProduto.Text := '';
    edtVlUnitario.Text := '';
    edtQuantidade.Text := '';
    edtDescricao.Text := '';
    edtPrecVenda.Text := '';
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar o produto: ' + E.Message);
  end;
end;

procedure TForm1.SalvarProduto;
var
  Codigo: Integer;
  ValorUnitario: Currency;
  Quantidade: Integer;
  Descricao: string;
  PrecoVenda: Currency;
  Condicao: Char;
begin
  try
    // Obter dados dos campos
    Codigo := StrToInt(edtCodProduto.Text);
    ValorUnitario := StrToCurr(edtVlUnitario.Text);
    Quantidade := StrToInt(edtQuantidade.Text);
    Descricao := edtDescricao.Text;
    PrecoVenda := StrToCurr(edtPrecVenda.Text);

    // Definir a condi��o ('I' para inserir, 'R' para remover)
    Condicao := 'I'; // Alterar para 'R' se desejar remover

    // Chama o m�todo para inserir ou remover o produto
    DataModule1.InserirOuRemoverProduto(Condicao, Codigo, Quantidade, ValorUnitario, Descricao, PrecoVenda);

    // Atualizar o grid
    DataModule1.CarregarProdutos; // Atualizar os dados ap�s a opera��o

    // Exibir mensagem de sucesso
    if Condicao = 'I' then
      ShowMessage('Produto inserido com sucesso.');

    // Limpar os campos ap�s salvar
    edtCodProduto.Text := '';
    edtVlUnitario.Text := '';
    edtQuantidade.Text := '';
    edtDescricao.Text := '';
    edtPrecVenda.Text := '';
  except
    on E: Exception do
      ShowMessage('Erro ao salvar o produto: ' + E.Message);
  end;
end;

procedure TForm1.AtualizarTotalPedidos;
var
  Total: Currency;
begin
  Total := 0;

  // Verifica se o DataSet est� aberto
  if DataModule1.FDQueryProdutos.Active then
  begin
    DataModule1.FDQueryProdutos.First;
    while not DataModule1.FDQueryProdutos.Eof do
    begin
      Total := Total + DataModule1.FDQueryProdutos.FieldByName('vlUnitario').AsCurrency *
               DataModule1.FDQueryProdutos.FieldByName('quantidade').AsInteger;
      DataModule1.FDQueryProdutos.Next;
    end;
  end;

  // Atualiza o StatusBar com o total dos pedidos
  StatusBar1.Panels[0].Text := Format('Total dos Pedidos: %.2f', [Total]);
end;

end.

