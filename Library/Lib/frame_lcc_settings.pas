unit frame_lcc_settings;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Spin,
  Buttons, synaser, lcc_app_common_settings, Dialogs, LResources,
  lcc_raspberrypi, contnrs;

type

  TFrameLccSettings = class;

  { TUserSettings }

  TUserSettings = class(TPersistent)
  private
    FOwnerSettings: TFrameLccSettings;
    function GetComPort: Boolean;
    function GetEthernetClient: Boolean;
    function GetEthernetServer: Boolean;
    function GetRaspberryPiSpiPort: Boolean;
    function GetResizeParentForm: Boolean;
    procedure SetComPort(AValue: Boolean);
    procedure SetEthernetClient(AValue: Boolean);
    procedure SetEthernetServer(AValue: Boolean);
    procedure SetRaspberryPiSpiPort(AValue: Boolean);
    procedure SetResizeParentForm(AValue: Boolean);
  public
    property OwnerSettings: TFrameLccSettings read FOwnerSettings write FOwnerSettings;
  published
    property ComPort: Boolean read GetComPort write SetComPort;
    property RaspberryPiSpiPort: Boolean read GetRaspberryPiSpiPort write SetRaspberryPiSpiPort;
    property EthernetClient: Boolean read GetEthernetClient write SetEthernetClient;
    property EthernetServer: Boolean read GetEthernetServer write SetEthernetServer;
    property ResizeParentForm: Boolean read GetResizeParentForm write SetResizeParentForm;
  end;

  { TFrameLccSettings }

  TFrameLccSettings = class(TFrame)
    BitBtnRescanComPorts: TBitBtn;
    BitBtnRescanPiSpiPorts: TBitBtn;
    ButtonCancel: TButton;
    ButtonOk: TButton;
    ButtonSetLoopbackClient: TButton;
    ButtonSetLoopbackServer: TButton;
    ButtonSetLoopbackRemote: TButton;
    CheckBoxAutoResolveLocalAddressClient: TCheckBox;
    CheckBoxAutoResolveLocalAddressServer: TCheckBox;
    ComboBoxSpiSpeed: TComboBox;
    ComboBoxSpiMode: TComboBox;
    ComboBoxSpiBits: TComboBox;
    ComboBoxComPort: TComboBox;
    ComboBoxPiSpiPort: TComboBox;
    EditLocalClientIP: TEdit;
    EditLocalListenerIP: TEdit;
    EditRemoteListenerIP: TEdit;
    GroupBoxComPort: TGroupBox;
    GroupBoxPiSpiPort: TGroupBox;
    GroupBoxEthernetClient: TGroupBox;
    GroupBoxEthernetServer: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelLocalIP: TLabel;
    LabelLocalIP1: TLabel;
    LabelLocalPort: TLabel;
    LabelLocalPort1: TLabel;
    LabelRemoteIP: TLabel;
    LabelRemotePort: TLabel;
    SpinEditLocalClientPort: TSpinEdit;
    SpinEditLocalListenerPort: TSpinEdit;
    SpinEditRemoteListenerPort: TSpinEdit;
    procedure BitBtnRescanPiSpiPortsClick(Sender: TObject);
    procedure BitBtnRescanComPortsClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonSetLoopbackClientClick(Sender: TObject);
    procedure ButtonSetLoopbackRemoteClick(Sender: TObject);
    procedure ButtonSetLoopbackServerClick(Sender: TObject);
    procedure CheckBoxAutoResolveLocalAddressClientChange(Sender: TObject);
    procedure CheckBoxAutoResolveLocalAddressServerChange(Sender: TObject);
    procedure ComboBoxComPortChange(Sender: TObject);
    procedure EditRemoteListenerIPExit(Sender: TObject);
    procedure EditRemoteListenerIPKeyPress(Sender: TObject; var Key: char);
    procedure SpinEditRemoteListenerPortExit(Sender: TObject);
    procedure SpinEditRemoteListenerPortKeyPress(Sender: TObject; var Key: char);
  private
    FLockSetting: Boolean;
  private
    FComPort: Boolean;
    FEthernetClient: Boolean;
    FEthernetServer: Boolean;
    FLccSettings: TLccSettings;
    FPiSpiPort: Boolean;
    FResizeParentForm: Boolean;
    FUserSettings: TUserSettings;
    { private declarations }
    procedure SetComPort(AValue: Boolean);
    procedure SetEthernetClient(AValue: Boolean);
    procedure SetEthernetServer(AValue: Boolean);
    procedure SetPiSpiPort(AValue: Boolean);
    procedure SetResizeParentForm(AValue: Boolean);
    property LockSetting: Boolean read FLockSetting write FLockSetting;
  protected
    procedure PositionButtons;
    property ComPort: Boolean read FComPort write SetComPort;
    property PiSpiPort: Boolean read FPiSpiPort write SetPiSpiPort;
    property EthernetClient: Boolean read FEthernetClient write SetEthernetClient;
    property EthernetServer: Boolean read FEthernetServer write SetEthernetServer;
    property ResizeParentForm: Boolean read FResizeParentForm write SetResizeParentForm;
  public
    { public declarations }
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure SyncWithLccSettings;
    procedure ScanComPorts;
    procedure ScanRaspberryPiSpi;
    procedure StoreSettings;
  published
    property LccSettings: TLccSettings read FLccSettings write FLccSettings;
    property UserSettings: TUserSettings read FUserSettings write FUserSettings;
  end;

implementation

{$R *.lfm}

function GroupBoxSort(Item1, Item2: Pointer): Integer;
begin
  Result := TGroupBox( Item1).Tag - TGroupBox( Item2).Tag;
end;

{ TUserSettings }

function TUserSettings.GetComPort: Boolean;
begin
  Result := OwnerSettings.ComPort;
end;

function TUserSettings.GetEthernetClient: Boolean;
begin
  Result := OwnerSettings.EthernetClient;
end;

function TUserSettings.GetEthernetServer: Boolean;
begin
  Result := OwnerSettings.EthernetServer;
end;

function TUserSettings.GetRaspberryPiSpiPort: Boolean;
begin
  Result := OwnerSettings.PiSpiPort
end;

function TUserSettings.GetResizeParentForm: Boolean;
begin
  Result := OwnerSettings.ResizeParentForm;
end;


procedure TUserSettings.SetComPort(AValue: Boolean);
begin
  OwnerSettings.ComPort := AValue;
end;


procedure TUserSettings.SetEthernetClient(AValue: Boolean);
begin
  OwnerSettings.EthernetClient := AValue
end;

procedure TUserSettings.SetEthernetServer(AValue: Boolean);
begin
  OwnerSettings.EthernetServer := AValue
end;

procedure TUserSettings.SetRaspberryPiSpiPort(AValue: Boolean);
begin
 OwnerSettings.PiSpiPort := AValue
end;

procedure TUserSettings.SetResizeParentForm(AValue: Boolean);
begin
  OwnerSettings.ResizeParentForm := AValue
end;

{ TFrameLccSettings }

procedure TFrameLccSettings.BitBtnRescanComPortsClick(Sender: TObject);
begin
  ScanComPorts;
end;

procedure TFrameLccSettings.BitBtnRescanPiSpiPortsClick(Sender: TObject);
begin
  ScanRaspberryPiSpi;
end;

procedure TFrameLccSettings.ButtonOkClick(Sender: TObject);
begin
  StoreSettings
end;

procedure TFrameLccSettings.ButtonSetLoopbackClientClick(Sender: TObject);
begin
  EditLocalClientIP.Text := '127.0.0.1';
end;

procedure TFrameLccSettings.ButtonSetLoopbackRemoteClick(Sender: TObject);
begin
  EditRemoteListenerIP.Text := '127.0.0.1';
end;

procedure TFrameLccSettings.ButtonSetLoopbackServerClick(Sender: TObject);
begin
  EditLocalListenerIP.Text := '127.0.0.1';
end;

procedure TFrameLccSettings.CheckBoxAutoResolveLocalAddressClientChange(
  Sender: TObject);
begin
  EditLocalClientIP.Enabled := not CheckBoxAutoResolveLocalAddressClient.Checked;
end;

procedure TFrameLccSettings.CheckBoxAutoResolveLocalAddressServerChange(Sender: TObject);
begin
  EditLocalListenerIP.Enabled := not CheckBoxAutoResolveLocalAddressServer.Checked;
end;

procedure TFrameLccSettings.ComboBoxComPortChange(Sender: TObject);
begin
 // StoreSettings;
end;

constructor TFrameLccSettings.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FUserSettings := TUserSettings.Create;
  UserSettings.OwnerSettings := Self;
end;

destructor TFrameLccSettings.Destroy;
begin
  FreeAndNil(FUserSettings);
  inherited Destroy;
end;

procedure TFrameLccSettings.ScanComPorts;
begin
  if Assigned(LccSettings) then
  begin
    LockSetting := True;
    try
      ComboBoxComPort.Items.Delimiter := ';';
      ComboBoxComPort.Items.DelimitedText := StringReplace(GetSerialPortNames, ',', ';', [rfReplaceAll, rfIgnoreCase]);

      ComboBoxComPort.ItemIndex := ComboBoxComPort.Items.IndexOf(LccSettings.ComPort.Port);
      if (ComboBoxComPort.ItemIndex < 0) and (ComboBoxComPort.Items.Count > 0) then
        ComboBoxComPort.ItemIndex := 0;
    finally
      LockSetting := False;
    end;
  end;
end;

procedure TFrameLccSettings.ScanRaspberryPiSpi;
begin
  {$IFDEF CPUARM}
  if Assigned(LccSettings) then
  begin
    LockSetting := True;
    try

      ComboBoxPiSpiPort.Items.Delimiter := ';';
      ComboBoxPiSpiPort.Items.DelimitedText := StringReplace(GetRaspberryPiSpiPortNames, ',', ';', [rfReplaceAll, rfIgnoreCase]);

      ComboBoxPiSpiPort.ItemIndex := ComboBoxPiSpiPort.Items.IndexOf(LccSettings.ComPort.Port);
      if (ComboBoxPiSpiPort.ItemIndex < 0) and (ComboBoxPiSpiPort.Items.Count > 0) then
        ComboBoxPiSpiPort.ItemIndex := 0;
    finally
      LockSetting := False;
    end;
  end;
  {$ENDIF}
end;

procedure TFrameLccSettings.SetComPort(AValue: Boolean);
begin
  FComPort:=AValue;
  if csDesigning in ComponentState then Exit;
  GroupBoxComPort.Visible := FComPort;
  PositionButtons;
end;

procedure TFrameLccSettings.SetEthernetClient(AValue: Boolean);
begin
  FEthernetClient:=AValue;
  if csDesigning in ComponentState then Exit;
  GroupBoxEthernetClient.Visible := AValue;
  PositionButtons;
end;

procedure TFrameLccSettings.SetEthernetServer(AValue: Boolean);
begin
  FEthernetServer:=AValue;
  if csDesigning in ComponentState then Exit;
  GroupBoxEthernetServer.Visible := AValue;
  PositionButtons;
end;

procedure TFrameLccSettings.SetPiSpiPort(AValue: Boolean);
begin
  FPiSpiPort:=AValue;
  if csDesigning in ComponentState then Exit;
  GroupBoxPiSpiPort.Visible := FPiSpiPort;
  PositionButtons;
end;

procedure TFrameLccSettings.SetResizeParentForm(AValue: Boolean);
begin
  FResizeParentForm := AValue;
  PositionButtons;
end;

procedure TFrameLccSettings.SpinEditRemoteListenerPortExit(Sender: TObject);
begin
  StoreSettings;
end;

procedure TFrameLccSettings.SpinEditRemoteListenerPortKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    StoreSettings;
end;

procedure TFrameLccSettings.StoreSettings;
begin
  if not LockSetting and Assigned(LccSettings) then
  begin
    if LccSettings.FilePath = '' then
      ShowMessage('The SettingsFilePath is empty, can''t save the settings')
    else begin
      LccSettings.ComPort.Port := ComboBoxComPort.Caption;
      LccSettings.Ethernet.LocalClientIP := EditLocalClientIP.Text;
      LccSettings.Ethernet.LocalClientPort := SpinEditLocalClientPort.Value;
      LccSettings.Ethernet.RemoteListenerIP := EditRemoteListenerIP.Text;
      LccSettings.Ethernet.RemoteListenerPort := SpinEditRemoteListenerPort.Value;
      LccSettings.Ethernet.LocalListenerIP := EditLocalListenerIP.Text;
      LccSettings.Ethernet.LocalListenerPort := SpinEditLocalListenerPort.Value;
      LccSettings.Ethernet.AutoResolveListenerIP := CheckBoxAutoResolveLocalAddressServer.Checked;
      LccSettings.Ethernet.AutoResolveClientIP := CheckBoxAutoResolveLocalAddressClient.Checked;
      LccSettings.PiSpiPort.Port := ComboBoxPiSpiPort.Caption;
      LccSettings.PiSpiPort.Speed := TPiSpiSpeed( ComboBoxSpiSpeed.ItemIndex);
      LccSettings.PiSpiPort.Mode := TPiSpiMode( ComboBoxSpiMode.ItemIndex);
      LccSettings.PiSpiPort.Bits := TPiSpiBits( ComboBoxSpiBits.ItemIndex);
      LccSettings.SaveToFile;
    end;
  end;
end;

procedure TFrameLccSettings.EditRemoteListenerIPExit(Sender: TObject);
begin
  StoreSettings;
end;

procedure TFrameLccSettings.EditRemoteListenerIPKeyPress(Sender: TObject;
  var Key: char);
begin
  if Key = #13 then
    StoreSettings;
end;

procedure TFrameLccSettings.PositionButtons;

const
  MARGIN = 8;
var
  VisibleGroupBoxes: TObjectList;
  GroupBox, PrevGroupBox: TGroupBox;
  i: Integer;
  ParentControl: TWinControl;
begin
  VisibleGroupBoxes := TObjectList.Create;
  try
    VisibleGroupBoxes.OwnsObjects := False;

    for i := 0 to ControlCount - 1 do
    begin
      if Controls[i] is TGroupBox then
      begin
        GroupBox := (Controls[i] as TGroupBox);
        if GroupBox.Visible then
          VisibleGroupBoxes.Add(GroupBox);
      end;
    end;

    VisibleGroupBoxes.Sort(@GroupBoxSort);

    PrevGroupBox := nil;
    for i := 0 to VisibleGroupBoxes.Count - 1 do
    begin
      GroupBox := VisibleGroupBoxes[i] as TGroupBox;
      if not Assigned(PrevGroupBox) then
        GroupBox.Top := MARGIN
      else begin
        GroupBox.Top := PrevGroupBox.Top + PrevGroupBox.Height + MARGIN;
      end;
      PrevGroupBox := GroupBox;
    end;

    if Assigned(PrevGroupBox) then
    begin
      ButtonOk.Top := PrevGroupBox.Top + PrevGroupBox.Height + MARGIN;
      ButtonCancel.Top := PrevGroupBox.Top + PrevGroupBox.Height + MARGIN;
    end else
    begin
      ButtonOk.Top := MARGIN;
      ButtonCancel.Top := MARGIN;
    end;

    if ResizeParentForm then
    begin
      ParentControl := Parent;
      while (ParentControl <> nil) do
      begin
        if ParentControl is TForm then
        begin
          ParentControl.ClientHeight := ButtonOk.Top + ButtonOk.Height + MARGIN;
          Break;
        end;
        ParentControl := ParentControl.Parent;
      end;
    end;
  finally
    FreeAndNil(VisibleGroupBoxes)
  end;
end;

procedure TFrameLccSettings.SyncWithLccSettings;
begin
  if Assigned(LccSettings) then
  begin
    LockSetting := True;
    try
      BitBtnRescanComPorts.Click;
      BitBtnRescanPiSpiPorts.Click;
      EditLocalClientIP.Text := LccSettings.Ethernet.LocalClientIP;
      SpinEditLocalClientPort.Value := LccSettings.Ethernet.LocalClientPort;
      EditRemoteListenerIP.Text := LccSettings.Ethernet.RemoteListenerIP;
      SpinEditRemoteListenerPort.Value := LccSettings.Ethernet.RemoteListenerPort;
      EditLocalListenerIP.Text := LccSettings.Ethernet.LocalListenerIP;
      SpinEditLocalListenerPort.Value := LccSettings.Ethernet.LocalListenerPort;
      CheckBoxAutoResolveLocalAddressServer.Checked := LccSettings.Ethernet.AutoResolveListenerIP;
      CheckBoxAutoResolveLocalAddressClient.Checked := LccSettings.Ethernet.AutoResolveClientIP;
      ComboBoxPiSpiPort.ItemIndex := ComboBoxPiSpiPort.Items.IndexOf(LccSettings.PiSpiPort.Port);
      if (ComboBoxPiSpiPort.ItemIndex < 0) and (ComboBoxPiSpiPort.Items.Count > 0) then
        ComboBoxPiSpiPort.ItemIndex := 0;
      ComboBoxComPort.ItemIndex := ComboBoxComPort.Items.IndexOf(LccSettings.ComPort.Port);
      if (ComboBoxComPort.ItemIndex < 0) and (ComboBoxComPort.Items.Count > 0) then
        ComboBoxComPort.ItemIndex := 0;
      ComboBoxSpiSpeed.ItemIndex := Integer(   LccSettings.PiSpiPort.Speed);
      ComboBoxSpiMode.ItemIndex := Integer(   LccSettings.PiSpiPort.Mode);
      ComboBoxSpiBits.ItemIndex := Integer(   LccSettings.PiSpiPort.Bits);
      PositionButtons;
    finally
      LockSetting := False;
    end;
  end;
end;

end.

