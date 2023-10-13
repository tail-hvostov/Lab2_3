program Lab2_3;
Uses
    System.SysUtils;
Type
    IOPreference = (UseFile, UseStdIO);
    RealArr = Array Of Real;
Function GetInteger(MinLimit, MaxLimit : Integer; Mes : String) : Integer;
Var
    IsCyclical, ErrorFlag : Boolean;
    Num : Integer;
Begin
    IsCyclical := True;
    ErrorFlag := False;
    Num := 0;
    While IsCyclical Do
    Begin
        WriteLn(Mes);
        Try
            ReadLn(Num);
        Except
            ErrorFlag := True;
            WriteLn('Cannot read a number...');
        End;
        If Not ErrorFlag Then
        Begin
            If ((Num > MinLimit) And (Num < MaxLimit)) Then
                IsCyclical := False
            Else
                WriteLn('Enter valid data!');
        End;
        ErrorFlag := False;
    End;
    GetInteger := Num;
End;

Function GetReal(MinLimit, MaxLimit : Integer; Mes : String) : Real;
Var
    IsCyclical, ErrorFlag : Boolean;
    Num : Real;
Begin
    IsCyclical := True;
    ErrorFlag := False;
    Num := 0;
    While IsCyclical Do
    Begin
        WriteLn(Mes);
        Try
            ReadLn(Num);
        Except
            ErrorFlag := True;
            WriteLn('Cannot read a number...');
        End;
        If Not ErrorFlag Then
        Begin
            If ((Num > MinLimit) And (Num < MaxLimit)) Then
                IsCyclical := False
            Else
                WriteLn('Enter valid data!');
        End;
        ErrorFlag := False;
    End;
    GetReal := Num;
End;

Function GetString(Mes : String) : String;
Var Return : String;
Begin
    WriteLn(Mes);
    ReadLn(Return);
    GetString := Return;
End;

Function GetUserIOPreference() : IOPreference;
Const
    ANS_MAX = 2;
    ANS_MIN = -1;
Var
    Response : Integer;
Begin
    GetUserIOPreference := IOPreference.UseFile;
    Response := GetInteger(ANS_MIN, ANS_MAX, 'Select the mode of interface(0 - File, 1 - StdIO):');
    If Response = 1 Then
        GetUserIOPreference := IOPreference.UseStdIO;
End;

Procedure StdInput(Var PointX, PointY : Real; Var Abscisses, Ordinates : RealArr);
Const
    MAX_ABSCISSA = 10000;
    MIN_ABSCISSA = 0;
    MAX_ORDINATE = 10000;
    MIN_ORDINATE = 0;
    MAX_SIDES_AM = 48;
    MIN_SIDES_AM = 2;
Var SidesAm, I : Integer;
Begin
    SidesAm := GetInteger(MIN_SIDES_AM, MAX_SIDES_AM, 'Enter the amount of sides(from 3 to 47):');
    SetLength(Abscisses, SidesAm);
    SetLength(Ordinates, SidesAm);
    For I := 0 To High(Ordinates) Do
    Begin
        Abscisses[I] := GetReal(MIN_ABSCISSA, MAX_ABSCISSA, 'Enter a new abscissa:');
        Ordinates[I] := GetReal(MIN_ORDINATE, MAX_ORDINATE, 'Enter a new ordinate:');
    End;
    PointX := GetReal(MIN_ABSCISSA, MAX_ABSCISSA, 'Enter the abscissa of the point:');
    PointY := GetReal(MIN_ORDINATE, MAX_ORDINATE, 'Enter the ordinate of the point:');
End;

Procedure FileInput(Var PointX, PointY : Real; Var Abscisses, Ordinates : RealArr);
Const
    MAX_ABSCISSA = 10000;
    MIN_ABSCISSA = 0;
    MAX_ORDINATE = 10000;
    MIN_ORDINATE = 0;
    MAX_SIDES_AM = 48;
    MIN_SIDES_AM = 3;
Var
    IsCyclical, SuccessFlag : Boolean;
    Path : String;
    Input : TextFile;
    SidesAm, I : Integer;
Begin
    IsCyclical := True;
    SuccessFlag := True;
    While IsCyclical Do
    Begin
        Path := GetString('Enter a path:');
        If Not FileExists(Path) Then
        Begin
            SuccessFlag := False;
            WriteLn('This file does not exist!!');
        End;
        If SuccessFlag Then
        Begin
            AssignFile(Input, Path);
            Reset(Input);
            Try
                ReadLn(Input, SidesAm);
            Except
                SuccessFlag := False;
                WriteLn('Cannot read a number...');
                CloseFile(Input);
            End;
        End;
        If SuccessFlag Then
        Begin
            SetLength(Abscisses, SidesAm);
            SetLength(Ordinates, SidesAm);
            I := 0;
            While SuccessFlag And (I < SidesAm) Do
            Begin
                Try
                    ReadLn(Input, Abscisses[I], Ordinates[I]);
                Except
                    SuccessFlag := False;
                    WriteLn('Cannot read a number...');
                    CloseFile(Input);
                End;
                I := I + 1;
            End;
        End;
        If SuccessFlag Then
        Begin
            Try
                ReadLn(Input, PointX, PointY);
            Except
                SuccessFlag := False;
                WriteLn('Cannot read a number...');
                CloseFile(Input);
            End;
        End;
        If SuccessFlag Then
        Begin
            CloseFile(Input);
            IsCyclical := False;
        End;
    End;
End;

Procedure LoadData(Var PointX, PointY : Real; Var Abscisses, Ordinates : RealArr);
Var Preference : IOPreference;
Begin
    Preference := GetUserIOPreference();
    If (Preference = IOPreference.UseStdIO) Then
        StdInput(PointX, PointY, Abscisses, Ordinates)
    Else
    Begin
        WriteLn('--------File scheme--------');
        WriteLn('1    . Amount of points.');
        WriteLn('2-N+1. Abscissa Ordinate');
        WriteLn('N+2  . PointX PointY');
        FileInput(PointX, PointY, Abscisses, Ordinates);
    End;
End;

Var
    PointX, PointY : Real;
    Abscisses, Ordinates : RealArr;
Begin
    WriteLn(' This program finds out if a point lies inside a polygon.');
    WriteLn('Loading data...');
    LoadData(PointX, PointY, Abscisses, Ordinates);
    ReadLn;
End.
