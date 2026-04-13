uses crt;
var x:longint;
    k,a,b:integer;
    n,m,i,j:longint;
    mine:array [1..2,0..100,0..100] of char;
PROCEDURE clear(a,b:byte);
begin
   for i:= 2 to 6 do
    begin
     gotoxy(1,a+i-2);
     clreol;
    end;
   gotoxy(b,a);
end;

//ctc dung de chon level khi choi
PROCEDURE level;
var kt:boolean;
begin
   clrscr;
   n:=0;
   while (n<1) or (n>9) do
    begin
     writeln('Choose level');
     writeln('1: Beginner 1');
     writeln('2: Beginner 2');
     writeln('3: Beginner 3');
     writeln('4: Easy');
     writeln('5: Normal');
     writeln('6: Intermediary');
     writeln('7: Difficult');
     writeln('8: Advanced');
     writeln('9: Elective');
     write('Please choose the level to play: ');
     readln(n);
    end;
   case n of
    1:begin n:=5; m:=5; k:=5 end;
    2:begin n:=8; m:=8; k:=10 end;
    3:begin n:=8; m:=8; k:=15 end;
    4:begin n:=10; m:=10; k:=25 end;
    5:begin n:=10; m:=15; k:=45 end;
    6:begin n:=13; m:=18; k:=50 end;
    7:begin n:=15; m:=20; k:=80 end;
    8:begin n:=15; m:=20; k:=100 end;
    9:begin
       kt:=false;
       while not kt do
        begin
         clrscr;
         writeln('Row <= 15     Clumn <= 20     Mine < 300');
         writeln;
         write('Row     = ');readln(n);
         write('Column  = ');readln(m);
         write('Mine    = ');readln(k);
         if (n>0) and (n<16) and (m>0) and (m<21) and (k>0) and (k<301)
          then kt:=true;
        end;
      end;
    end;
   clrscr;
   writeln('0:start game');
   writeln('1:come back');
   readln(x);
   case x of
    0:begin clrscr; exit; end;
    1:level;
   end;
end;

PROCEDURE fill;
begin
   clrscr;
   Mine[1,0,0]:='0';
   Mine[2,0,0]:='O';

   for i:= 1 to n do
    for j:= 1 to m do
     begin
      Mine[1,i,j]:='0';
      Mine[2,i,j]:='.';
     end;

   gotoxy(1,1);
   write('O');

   for i:= 1 to n do
    begin
     gotoxy(1,i+1);
     write(i);
    end;

   for i:= 1 to m do
    if i<10 then
     begin
      gotoxy(i*3+1,1);
      write(i);
     end else
     begin
      gotoxy(i*3,1);
      write(i);
     end;

   for i:= 1 to n do
    for j:= 1 to m do
     begin
      gotoxy(j*3+1,i+1);
      write('.');
     end;
   gotoxy(1,n+2);
end;

//ctc xu ly du lieu truoc khi choi
PROCEDURE handle(n,m,k:integer);
var kt:boolean;
    c,d:integer;
begin
   randomize;
//vong lap tao random qua min tren man hinh
   for i:= 1 to k do
    begin
     kt:=false;
     while not kt do
      begin
       c:=random(n);
       d:=random(m);
       if (mine[1,c,d]<>'*') and (c<>a) and (d<>b) and (c>0) and (d>0) then
        begin
         mine[1,c,d]:='*';
         kt:=true;
        end;
      end;
    end;

//vong lap tao cac so qua min khi in ra man hinh
   for i:= 1 to n do
    for j:= 1 to m do
     if mine[1,i,j]='*' then
      for c:= i-1 to i+1 do
       for d:= j-1 to j+1 do
        if mine[1,c,d]<>'*' then
         mine[1,c,d]:=chr(ord(mine[1,c,d])+1);
end;

PROCEDURE input;
begin
   write('Mines[a,b] = '); readln(a,b);

   if (a=0) and (b=0) then
    begin
     if Mine[2,0,0]='O' then Mine[2,0,0]:='L' else Mine[2,0,0]:='O';
     gotoxy(1,1);
     write(Mine[2,0,0]);
     clear(n+2,1);
     input;
     exit;
    end;

   if (a<1) or (a>n) or (b<1) or (b>m) then
    begin
     clear(n+2,1);
     writeln('The address you just entered could not be found!');
     writeln('Please re-enter!');
     input;
     exit;
    end;

   if (Mine[2,a,b]<>'.') and (Mine[2,a,b]<>'L') then
    begin
     clear(n+2,1);
     writeln('The address you just entered has been displayed!');
     writeln('Please re-enter!');
     input;
     exit;
    end;

   if (Mine[2,0,0]='O') and (Mine[2,a,b]='L') then
    begin
     clear(n+2,1);
     writeln('The address you just entered has been locked!');
     writeln('Please re-enter!');
     input;
    end;
   clear(n+2,1);
end;

PROCEDURE print(a,b:byte);
begin
   if (a=0) or (b=0) then exit;
   gotoxy(b*3+1,a+1);
   if (Mine[2,0,0]='L') then
    begin
     if Mine[2,a,b]='.' then
      begin
       write('L');
       Mine[2,a,b]:='L';
       gotoxy(1,n+2);
       if Mine[1,a,b]='*' then inc(x);
       exit;
      end;

     if Mine[2,a,b]='L' then
      begin
       write('.');
       Mine[2,a,b]:='.';
       gotoxy(1,n+2);
       if Mine[1,a,b]='*' then dec(x);
       exit;
      end;
    end;
   if (Mine[1,a,b])='0' then write(' ') else
   write(Mine[1,a,b]);
   Mine[2,a,b]:=Mine[1,a,b];
   inc(x);
   gotoxy(1,n+2);

   if (Mine[1,a-1,b]='0') and (Mine[2,a-1,b]='.') then print(a-1,b) else
    if (Mine[1,a,b]='0') and (Mine[1,a-1,b]<>'0') and (Mine[2,a-1,b]='.')
     then begin
      gotoxy(b*3+1,a);
      write(Mine[1,a-1,b]);
      Mine[2,a-1,b]:=Mine[1,a-1,b];
      inc(x);
      gotoxy(1,n+2);
     end;

   if (Mine[1,a+1,b]='0') and (Mine[2,a+1,b]='.') then print(a+1,b) else
    if (Mine[1,a,b]='0') and (Mine[1,a+1,b]<>'0') and (Mine[2,a+1,b]='.')
     then begin
      gotoxy(b*3+1,a+2);
      write(Mine[1,a+1,b]);
      Mine[2,a+1,b]:=Mine[1,a+1,b];
      inc(x);
      gotoxy(1,n+2);
     end;

   if (Mine[1,a,b-1]='0') and (Mine[2,a,b-1]='.') then print(a,b-1) else
    if (Mine[1,a,b]='0') and (Mine[1,a,b-1]<>'0') and (Mine[2,a,b-1]='.')
     then begin
      gotoxy((b-1)*3+1,a+1);
      write(Mine[1,a,b-1]);
      Mine[2,a,b-1]:=Mine[1,a,b-1];
      inc(x);
      gotoxy(1,n+2);
     end;

   if (Mine[1,a,b+1]='0') and (Mine[2,a,b+1]='.') then print(a,b+1) else
    if (Mine[1,a,b]='0') and (Mine[1,a,b+1]<>'0') and (Mine[2,a,b+1]='.')
     then begin
      gotoxy((b+1)*3+1,a+1);
      write(Mine[1,a,b+1]);
      Mine[2,a,b+1]:=Mine[1,a,b+1];
      inc(x);
      gotoxy(1,n+2);
     end;

   if (Mine[1,a-1,b-1]='0') and (Mine[2,a-1,b-1]='.') then print(a-1,b-1) else
    if (Mine[1,a,b]='0') and (Mine[1,a-1,b-1]<>'0') and (Mine[2,a-1,b-1]='.')
     then begin
      gotoxy((b-1)*3+1,a);
      write(Mine[1,a-1,b-1]);
      Mine[2,a-1,b-1]:=Mine[1,a-1,b-1];
      inc(x);
      gotoxy(1,n+2);
     end;

   if (Mine[1,a-1,b+1]='0') and (Mine[2,a-1,b+1]='.') then print(a-1,b+1) else
    if (Mine[1,a,b]='0') and (Mine[1,a-1,b+1]<>'0') and (Mine[2,a-1,b+1]='.')
     then begin
      gotoxy((b+1)*3+1,a);
      write(Mine[1,a-1,b+1]);
      Mine[2,a-1,b+1]:=Mine[1,a-1,b+1];
      inc(x);
      gotoxy(1,n+2);
     end;

   if (Mine[1,a+1,b+1]='0') and (Mine[2,a+1,b+1]='.') then print(a+1,b+1) else
    if (Mine[1,a,b]='0') and (Mine[1,a+1,b+1]<>'0') and (Mine[2,a+1,b+1]='.')
     then begin
      gotoxy((b+1)*3+1,a+2);
      write(Mine[1,a+1,b+1]);
      Mine[2,a+1,b+1]:=Mine[1,a+1,b+1];
      inc(x);
      gotoxy(1,n+2);
     end;

   if (Mine[1,a+1,b-1]='0') and (Mine[2,a+1,b-1]='.') then print(a+1,b-1) else
    if (Mine[1,a,b]='0') and (Mine[1,a+1,b-1]<>'0') and (Mine[2,a+1,b-1]='.')
     then begin
      gotoxy((b-1)*3+1,a+2);
      write(Mine[1,a+1,b-1]);
      Mine[2,a+1,b-1]:=Mine[1,a+1,b-1];
      inc(x);
      gotoxy(1,n+2);
     end;
end;

PROCEDURE print1;
begin
   clear(n+2,1);
   gotoxy(b*3,a+1);
   write('**');
   for i:= 1 to n do
    for j:= 1 to m do
     if (Mine[1,i,j]='*') and (Mine[2,i,j]='.') then
      begin gotoxy(j*3+1,i+1); write('*'); end else
       if (Mine[1,i,j]<>'*') and (Mine[2,i,j]='L') then
        begin gotoxy(j*3,i+1); write('x'); end;
   gotoxy((m*3-9) div 2,n+2);
   writeln('YOU LOSE!');
end;

BEGIN
   clrscr;
   level;
   fill;
   write('Mines[a,b] = '); readln(a,b);
   while (a<1) or (a>n) or (b<1) or (b>m) do
    begin
     clear(n+2,1);
     writeln('The address you just entered could not be found!');
     writeln('Please re-enter!');
     write('Mines[a,b] = '); readln(a,b);
    end;
   clear(n+2,1);
   handle(n,m,k);
   x:=0;
   print(a,b);
   while x<m*n do
    begin
     input;
     if (Mine[2,0,0]='L') or ((Mine[2,0,0]='O') and (Mine[1,a,b]<>'*')) then
      print(a,b) else begin print1; readln; exit end;
    end;
   gotoxy((m*3-7) div 2,n+2);
   writeln('YOU WIN');
   readln;
END.
