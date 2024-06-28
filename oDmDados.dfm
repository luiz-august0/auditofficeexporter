object dmDados: TdmDados
  OldCreateOrder = False
  Height = 160
  Width = 171
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    Properties.Strings = (
      'controls_cp=GET_ACP')
    TransactIsolationLevel = tiReadCommitted
    HostName = ''
    Port = 0
    Database = ''
    User = 'sa'
    Password = 'sa'
    Protocol = 'mssql'
    Left = 96
    Top = 16
  end
  object ZQuery: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      '')
    Params = <>
    Left = 104
    Top = 72
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider'
    Left = 24
    Top = 16
  end
  object DataSetProvider: TDataSetProvider
    DataSet = ZQuery
    Left = 32
    Top = 64
  end
end
