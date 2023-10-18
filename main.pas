Program Lab2_3;
Uses
    System.SysUtils;
Type
    IOPreference = (UseFile, UseStdIO);
    IntersectionState = (DoNotIntersect, Intersect, Belong, Failure);
    //В качестве Fail я определил ситуацию, когда две точки одного
    //ребра совпадают.
    ResultState = (Fail, Belonging, NotBelonging);
    RealArr = Array Of Real;
Const
    MAX_ABSCISSA = 10000;
    MIN_ABSCISSA = 0;
    MAX_ORDINATE = 10000;
    MIN_ORDINATE = 0;
    MAX_SIDES_AM = 48;
    MIN_SIDES_AM = 2;
    FLOAT_ADMISSION = 0.00000001;
    ANS_MAX = 2;
    ANS_MIN = -1;

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

//Nail переводится как "забрать".
Function NailInteger(MinLimit, MaxLimit : Integer; Mes : String) : Integer;
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
    NailInteger := Num;
End;

Function GoodReal(MinLimit, MaxLimit, Num : Real) : Boolean;
Begin
    //Минус перед поправкой учитывает возможное "заступание" Num за лимиты
    //вследствие воздействия побочных чисел и случай равенства Num с одним
    //из лимитов.
    GoodReal := ((Num - MinLimit > -FLOAT_ADMISSION) And (-FLOAT_ADMISSION < MaxLimit - Num));
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

//Nail переводится как "забрать".
Function NailReal(MinLimit, MaxLimit : Real; Mes : String) : Real;
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
    NailReal := Num;
End;

//Nail переводится как "забрать".
Function NailString(Mes : String) : String;
Var Return : String;
Begin
    WriteLn(Mes);
    ReadLn(Return);
    NailString := Return;
End;

//Nail переводится как "забрать".
Function NailUserIOPreference() : IOPreference;
Var
    Response : Integer;
Begin
    NailUserIOPreference := IOPreference.UseFile;
    Response := NailInteger(ANS_MIN, ANS_MAX, 'Select the mode of interface(0 - File, 1 - StdIO):');
    If Response = 1 Then
        NailUserIOPreference := IOPreference.UseStdIO;
End;

Procedure StdInput(Var PointX, PointY : Real; Var Abscisses, Ordinates : RealArr);
Var SidesAm, I : Integer;
Begin
    SidesAm := NailInteger(MIN_SIDES_AM, MAX_SIDES_AM, 'Enter the amount of sides(from 3 to 47):');
    SetLength(Abscisses, SidesAm);
    SetLength(Ordinates, SidesAm);
    For I := 0 To High(Ordinates) Do
    Begin
        Abscisses[I] := NailReal(MIN_ABSCISSA, MAX_ABSCISSA, 'Enter a new abscissa(0-10000):');
        Ordinates[I] := NailReal(MIN_ORDINATE, MAX_ORDINATE, 'Enter a new ordinate(0-10000):');
    End;
    PointX := NailReal(MIN_ABSCISSA, MAX_ABSCISSA, 'Enter the abscissa of the point(0-10000):');
    PointY := NailReal(MIN_ORDINATE, MAX_ORDINATE, 'Enter the ordinate of the point(0-10000):');
End;

Procedure ReadRealPair(Var SuccessFlag : Boolean; Var Input : TextFile; Var Val1, Val2 : Real);
Begin
    If SuccessFlag And Eoln(Input) Then
    Begin
        WriteLn('Bad input!');
        SuccessFlag := False;
    End;
    If SuccessFlag Then
    Begin
        Try
            Read(Input, Val1);
        Except
            SuccessFlag := False;
            WriteLn('Cannot read a number...');
        End;
    End;
    If SuccessFlag Then
        SuccessFlag := GoodRealWithBlame(MIN_ABSCISSA, MAX_ABSCISSA, Val1);
    If SuccessFlag And Eoln(Input) Then
    Begin
        WriteLn('Bad input!');
        SuccessFlag := False;
    End;
    If SuccessFlag Then
    Begin
        Try
            ReadLn(Input, Val2);
        Except
            SuccessFlag := False;
            WriteLn('Cannot read a number...');
        End;
    End;
    If SuccessFlag Then
        SuccessFlag := GoodRealWithBlame(MIN_ORDINATE, MAX_ORDINATE, Val2);
End;

Procedure PrepareFileForReading(Var TargetFile : TextFile; Var SuccessFlag, IsOpen : Boolean);
Var
    Path : String;
Begin
    Path := NailString('Enter a path:');
    If Copy(Path, (High(Path) - 3), 4) <> '.txt' Then
    Begin
        SuccessFlag := False;
        WriteLn('You are only allowed to use .txt!!');
    End;
    If SuccessFlag And (Not FileExists(Path)) Then
    Begin
        SuccessFlag := False;
        WriteLn('This file does not exist!!');
    End;
    If SuccessFlag Then
    Begin
        AssignFile(TargetFile, Path);
        Reset(TargetFile);
        IsOpen := True;
    End;
End;

Procedure PrepareFileForWriting(Var TargetFile : TextFile; Var SuccessFlag, IsOpen : Boolean);
Var
    Path : String;
Begin
    Path := NailString('Enter a path:');
    If Copy(Path, (High(Path) - 3), 4) <> '.txt' Then
    Begin
        SuccessFlag := False;
        WriteLn('You are only allowed to use .txt!!');
    End;
    If SuccessFlag Then
    Begin
        AssignFile(TargetFile, Path);
        IsOpen := True;
        Try
            Rewrite(TargetFile);
        Except
            WriteLn('Writing is impossible!!');
            SuccessFlag := False;
        End;
    End;
End;

Procedure FileInput(Var PointX, PointY : Real; Var Abscisses, Ordinates : RealArr);
Var
    IsCyclical, SuccessFlag, IsOpen : Boolean;
    Input : TextFile;
    SidesAm, I : Integer;
Begin
    IsCyclical := True;
    While IsCyclical Do
    Begin
        IsOpen := False;
        SuccessFlag := True;
        PrepareFileForReading(Input, SuccessFlag, IsOpen);
        If SuccessFlag And Eoln(Input) Then
        Begin
            WriteLn('Bad input!');
            SuccessFlag := False;
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
                ReadRealPair(SuccessFlag, Input, Abscisses[I], Ordinates[I]);
                I := I + 1;
            End;
        End;
        ReadRealPair(SuccessFlag, Input, PointX, PointY);
        If SuccessFlag Then
            IsCyclical := False;
        If IsOpen Then
            CloseFile(Input);
    End;
End;

Procedure LoadData(Var PointX, PointY : Real; Var Abscisses, Ordinates : RealArr);
Var
    Preference : IOPreference;
Begin
    Preference := NailUserIOPreference();
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

Procedure SortPair(Var Biggest, Smallest : Real; Const Val1, Val2 : Real);
Begin
    If Val1 - Val2 > FLOAT_ADMISSION Then
    Begin
        Biggest := Val1;
        Smallest := Val2;
    End
    Else
    Begin
        Biggest := Val2;
        Smallest := Val1;
    End;
End;

Function CheckIntersection(Const PointX, PointY, FirstAbscissa, FirstOrdinate, SecondAbscissa, SecondOrdinate : Real) : IntersectionState;
Var
    BigY, SmallY, BigX, SmallX : Real;//Отсортированные концы отрезка.
    IntersectionX : Real;
    Virtue : Boolean;
Begin
    CheckIntersection := IntersectionState.DoNotIntersect;
    If (Abs(FirstAbscissa - SecondAbscissa) < FLOAT_ADMISSION) And (Abs(FirstOrdinate - SecondOrdinate) < FLOAT_ADMISSION) Then
        //Отрезок не существует.
        CheckIntersection := IntersectionState.Failure
    Else
    Begin
        SortPair(BigX, SmallX, FirstAbscissa, SecondAbscissa);
        SortPair(BigY, SmallY, FirstOrdinate, SecondOrdinate);
        If BigY - SmallY > FLOAT_ADMISSION Then
        Begin
            IntersectionX := SecondAbscissa + (PointY - SecondOrdinate) * (SecondAbscissa - FirstAbscissa) / (SecondOrdinate - FirstOrdinate);
            If IntersectionX - PointX > FLOAT_ADMISSION Then
            Begin
                CheckIntersection := IntersectionState.Intersect;
                If Abs(PointX - IntersectionX) < FLOAT_ADMISSION Then
                    CheckIntersection := IntersectionState.Belong;
            End;
        End
        Else
        Begin
            Virtue := GoodReal(SmallX, BigX, PointX);
            If (Abs(PointY - SecondOrdinate) < FLOAT_ADMISSION) And Virtue Then
                CheckIntersection := IntersectionState.Belong;
        End;
    End;
End;

//Принцип работы - пуск луча вправо из заданной точки.
//Нечётное число пересечений с рёбрами - вхождение.
//Дополнительно проверяется принадлежность точки ребру.
Function Solve(Const PointX, PointY : Real; Const Abscisses, Ordinates : RealArr) : ResultState;
Var
    I, Intersections : Integer;
    NotBelongToLine, IsNotFailure : Boolean;
    CheckResult : IntersectionState;
Begin
    I := 0;
    Intersections := 0;
    NotBelongToLine := True;
    IsNotFailure := True;
    While (I < Length(Abscisses)) And NotBelongToLine And IsNotFailure Do
    Begin
        If I < High(Abscisses) Then
            CheckResult := CheckIntersection(PointX, PointY, Abscisses[I], Ordinates[I], Abscisses[I + 1], Ordinates[I + 1])
        Else
            CheckResult := CheckIntersection(PointX, PointY, Abscisses[I], Ordinates[I], Abscisses[0], Ordinates[0]);
        Case CheckResult Of
            IntersectionState.Belong:
                NotBelongToLine := False;
            IntersectionState.Intersect:
                Intersections := Intersections + 1;
            IntersectionState.Failure:
                //Такой вариант возможен, если отрезок не существует.
                IsNotFailure := False;
        End;
        I := I + 1;
    End;
    WriteLn(Intersections, ' intersections found.');
    Solve := ResultState.Fail;
    If IsNotFailure Then
    Begin
        If Not NotBelongToLine Then
            Solve := ResultState.Belonging
        Else
        Begin
            If Intersections Mod 2 = 1 Then
                Solve := ResultState.Belonging
            Else
                Solve := ResultState.NotBelonging;
        End;
    End;
End;

Procedure StdOutput(Const Output : ResultState);
Begin
    Case Output Of
        ResultState.Fail:
            WriteLn('The figure does not exist!!');
        ResultState.Belonging:
            WriteLn('The point lies inside the polygon.');
        ResultState.NotBelonging:
            WriteLn('The point does not lie inside the polygon.');
    End;
End;

Procedure FileOutput(Const Output : ResultState);
Var
    IsCyclical, SuccessFlag, IsOpen : Boolean;
    OutputFile : TextFile;
Begin
    IsCyclical := True;
    While IsCyclical Do
    Begin
        SuccessFlag := True;
        IsOpen := False;
        PrepareFileForWriting(OutputFile, SuccessFlag, IsOpen);
        If SuccessFlag Then
        Begin
            Case Output Of
                ResultState.Fail:
                    WriteLn(OutputFile, 'The figure does not exist!!');
                ResultState.Belonging:
                    WriteLn(OutputFile, 'The point lies inside the polygon.');
                ResultState.NotBelonging:
                    WriteLn(OutputFile, 'The point does not lie inside the polygon.');
            End;
        End;
        If SuccessFlag Then
            IsCyclical := False;
        If IsOpen Then
            CloseFile(Input);
    End;
End;

Procedure UnloadData(Const Output : ResultState);
Var
    Preference : IOPreference;
Begin
    Preference := NailUserIOPreference();
    If (Preference = IOPreference.UseStdIO) Then
        StdOutput(Output)
    Else
        FileOutput(Output);
End;

Var
    PointX, PointY : Real;
    Abscisses, Ordinates : RealArr;
    Output : ResultState;
Begin
    WriteLn(' This program finds out if a point lies inside a polygon.');
    WriteLn('Loading data...');
    LoadData(PointX, PointY, Abscisses, Ordinates);
    WriteLn('Solving the problem...');
    Output := Solve(PointX, PointY, Abscisses, Ordinates);
    WriteLn('Returning the result...');
    UnloadData(Output);
    ReadLn;
End.
