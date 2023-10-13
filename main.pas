Program Lab2_3;
Uses
    System.SysUtils;
Type
    IOPreference = (UseFile, UseStdIO);
    RealArr = Array Of Real;
Const
    MAX_ABSCISSA = 10000;
    MIN_ABSCISSA = 0;
    MAX_ORDINATE = 10000;
    MIN_ORDINATE = 0;
    MAX_SIDES_AM = 48;
    MIN_SIDES_AM = 2;

Function GoodInteger(MinLimit, MaxLimit, Num : Integer) : Boolean;
Begin
    GoodInteger := ((Num > MinLimit) And (Num < MaxLimit));
End;

//Blame переводится как порицание.
Function GoodIntegerWithBlame(MinLimit, MaxLimit, Num : Integer) : Boolean;
Var
    //Virtue переводится как хорошее качество.
    Virtue : Boolean;
Begin
    Virtue := GoodInteger(MinLimit, MaxLimit, Num);
    If Not Virtue Then
        WriteLn('Your input does not satisfy the requirements!!');
    GoodIntegerWithBlame := Virtue;
End;

Function GetInteger(MinLimit, MaxLimit : Integer; Mes : String) : Integer;
Var
    //Virtue переводится как хорошее качество.
    IsCyclical, ErrorFlag, Virtue : Boolean;
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
            Virtue := GoodInteger(MinLimit, MaxLimit, Num);
            If Virtue Then
                IsCyclical := False
            Else
                WriteLn('Enter valid data!');
        End;
        ErrorFlag := False;
    End;
    GetInteger := Num;
End;

Function GoodReal(MinLimit, MaxLimit, Num : Real) : Boolean;
Begin
    GoodReal := ((Num > MinLimit) And (Num < MaxLimit));
End;

//Blame переводится как порицание.
Function GoodRealWithBlame(MinLimit, MaxLimit, Num : Real) : Boolean;
Var
    //Virtue переводится как хорошее качество.
    Virtue : Boolean;
Begin
    Virtue := GoodReal(MinLimit, MaxLimit, Num);
    If Not Virtue Then
        WriteLn('Your input does not satisfy the requirements!!');
    GoodRealWithBlame := Virtue;
End;

Function GetReal(MinLimit, MaxLimit : Real; Mes : String) : Real;
Var
    //Virtue переводится как хорошее качество.
    IsCyclical, ErrorFlag, Virtue : Boolean;
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
            Virtue := GoodReal(MinLimit, MaxLimit, Num);
            If Virtue Then
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
Var SidesAm, I : Integer;
Begin
    SidesAm := GetInteger(MIN_SIDES_AM, MAX_SIDES_AM, 'Enter the amount of sides(from 3 to 47):');
    SetLength(Abscisses, SidesAm);
    SetLength(Ordinates, SidesAm);
    For I := 0 To High(Ordinates) Do
    Begin
        Abscisses[I] := GetReal(MIN_ABSCISSA, MAX_ABSCISSA, 'Enter a new abscissa(0-10000):');
        Ordinates[I] := GetReal(MIN_ORDINATE, MAX_ORDINATE, 'Enter a new ordinate(0-10000):');
    End;
    PointX := GetReal(MIN_ABSCISSA, MAX_ABSCISSA, 'Enter the abscissa of the point(0-10000):');
    PointY := GetReal(MIN_ORDINATE, MAX_ORDINATE, 'Enter the ordinate of the point(0-10000):');
End;

Procedure FileInput(Var PointX, PointY : Real; Var Abscisses, Ordinates : RealArr);
Var
    IsCyclical, SuccessFlag, IsOpen : Boolean;
    Path : String;
    Input : TextFile;
    SidesAm, I : Integer;
Begin
    IsCyclical := True;
    IsOpen := False;
    While IsCyclical Do
    Begin
        SuccessFlag := True;
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
            IsOpen := True;
        End;
        If SuccessFlag Then
        Begin
            If Eoln(Input) Then
            Begin
                WriteLn('Bad input!');
                SuccessFlag := False;
            End;
        End;
        If SuccessFlag Then
        Begin
            Try
                ReadLn(Input, SidesAm);
            Except
                SuccessFlag := False;
                WriteLn('Cannot read a number...');
            End;
        End;
        If SuccessFlag Then
            SuccessFlag := GoodIntegerWithBlame(MIN_SIDES_AM, MAX_SIDES_AM, SidesAm);
        If SuccessFlag Then
        Begin
            SetLength(Abscisses, SidesAm);
            SetLength(Ordinates, SidesAm);
            I := 0;
            While SuccessFlag And (I < SidesAm) Do
            Begin
                //Я расценил проверку на SuccessFlag здесь как избыточную.
                If Eoln(Input) Then
                Begin
                    WriteLn('Bad input!');
                    SuccessFlag := False;
                End;
                If SuccessFlag Then
                Begin
                    Try
                        Read(Input, Abscisses[I]);
                    Except
                        SuccessFlag := False;
                        WriteLn('Cannot read a number...');
                    End;
                End;
                If SuccessFlag Then
                    SuccessFlag := GoodRealWithBlame(MIN_ABSCISSA, MAX_ABSCISSA, Abscisses[I]);
                If SuccessFlag Then
                Begin
                    If Eoln(Input) Then
                    Begin
                        WriteLn('Bad input!');
                        SuccessFlag := False;
                    End;
                End;
                If SuccessFlag Then
                Begin
                    Try
                        ReadLn(Input, Ordinates[I]);
                    Except
                        SuccessFlag := False;
                        WriteLn('Cannot read a number...');
                    End;
                End;
                If SuccessFlag Then
                    SuccessFlag := GoodRealWithBlame(MIN_ORDINATE, MAX_ORDINATE, Ordinates[I]);
                I := I + 1;
            End;
        End;
        If SuccessFlag And Eoln(Input) Then
        Begin
            WriteLn('Bad input!');
            SuccessFlag := False;
        End;
        If SuccessFlag Then
        Begin
            Try
                Read(Input, PointX);
            Except
                SuccessFlag := False;
                WriteLn('Cannot read a number...');
            End;
        End;
        If SuccessFlag Then
            SuccessFlag := GoodRealWithBlame(MIN_ABSCISSA, MAX_ABSCISSA, PointX);
        If SuccessFlag And Eoln(Input) Then
        Begin
            WriteLn('Bad input!');
            SuccessFlag := False;
        End;
        If SuccessFlag Then
        Begin
            Try
                ReadLn(Input, PointY);
            Except
                SuccessFlag := False;
                WriteLn('Cannot read a number...');
            End;
        End;
        If SuccessFlag Then
            SuccessFlag := GoodRealWithBlame(MIN_ORDINATE, MAX_ORDINATE, PointY);
        If SuccessFlag Then
            IsCyclical := False;
        If IsOpen Then
            CloseFile(Input);
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
        WriteLn('--------------File scheme--------------');
        WriteLn('1    . Amount of points(from 3 to 47).');
        WriteLn('2-N+1. Abscissa Ordinate(0-10000)');
        WriteLn('N+2  . PointX PointY(0-10000)');
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
