unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.DataSet, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, Data.DBXMySQL,
  Data.FMTBcd, FireDAC.Stan.Param, Datasnap.DBClient, Datasnap.Provider,
  Data.DB, Data.SqlExpr;

type
  TDataModule1 = class(TDataModule)
    FDQuery1: TFDQuery;
    FDQueryProdutos: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InserirOuRemoverProduto(p_condicao: Char; p_codProduto: Integer;
      p_quantidade: Integer; p_vlUnitario: Currency; p_descricao: string; p_precVenda: Currency);
    procedure AtualizarGrid;
    procedure CarregarProdutos;
    procedure GravarPedido(p_numPedido: Integer; p_dtEmissao: TDateTime; p_codCliente: Integer;
                            p_vlTotal: Currency; p_codProduto: Integer; p_quantidade: Integer;
                            p_vlUnitario: Currency);
   end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TDataModule1.InserirOuRemoverProduto(p_condicao: Char; p_codProduto: Integer;
  p_quantidade: Integer; p_vlUnitario: Currency; p_descricao: string; p_precVenda: Currency);
begin
  // Configura a consulta para chamar a stored procedure
  FDQuery1.SQL.Text := 'CALL Insere_Remove_Produtos(:p_condicao, :p_codProduto, :p_quantidade, :p_vlUnitario, :p_descricao, :p_precVenda)';

  // Define os par�metros da consulta
  FDQuery1.ParamByName('p_condicao').AsString := p_condicao;
  FDQuery1.ParamByName('p_codProduto').AsInteger := p_codProduto;
  FDQuery1.ParamByName('p_quantidade').AsInteger := p_quantidade;
  FDQuery1.ParamByName('p_vlUnitario').AsCurrency := p_vlUnitario;
  FDQuery1.ParamByName('p_descricao').AsString := p_descricao;
  FDQuery1.ParamByName('p_precVenda').AsCurrency := p_precVenda;

  // Executa a consulta
  try
    FDQuery1.ExecSQL;
  except
   // on E: Exception do
     // ShowMessage('Erro ao executar procedure: ' + E.Message);
  end;

  AtualizarGrid;  // Atualiza o grid ap�s a execu��o
end;

procedure TDataModule1.AtualizarGrid;
begin
  FDQuery1.SQL.Text := 'SELECT * FROM Produtos';  // Supondo que voc� queira mostrar produtos
  FDQuery1.Open;
end;

procedure TDataModule1.CarregarProdutos;
begin
  FDQueryProdutos.SQL.Text := 'CALL Obtem_Produtos';
  FDQueryProdutos.Open;
end;

procedure TDataModule1.GravarPedido(p_numPedido: Integer; p_dtEmissao: TDateTime; p_codCliente: Integer;
                                     p_vlTotal: Currency; p_codProduto: Integer; p_quantidade: Integer;
                                     p_vlUnitario: Currency);
begin
  // Configura a consulta para chamar a stored procedure
  FDQuery1.SQL.Text := 'CALL Gravar_Pedido(:p_numPedido, :p_dtEmissao, :p_codCliente, :p_vlTotal, :p_codProduto, :p_quantidade, :p_vlUnitario)';

  FDQueryProdutos.Close;
  FDQueryProdutos.Params.ParamByName('p_numPedido').AsInteger := p_numPedido;
  FDQueryProdutos.Params.ParamByName('p_dtEmissao').AsDateTime := p_dtEmissao;
  FDQueryProdutos.Params.ParamByName('p_codCliente').AsInteger := p_codCliente;
  FDQueryProdutos.Params.ParamByName('p_vlTotal').AsCurrency := p_vlTotal;
  FDQueryProdutos.Params.ParamByName('p_codProduto').AsInteger := p_codProduto;
  FDQueryProdutos.Params.ParamByName('p_quantidade').AsInteger := p_quantidade;
  FDQueryProdutos.Params.ParamByName('p_vlUnitario').AsCurrency := p_vlUnitario;
end;

end.

