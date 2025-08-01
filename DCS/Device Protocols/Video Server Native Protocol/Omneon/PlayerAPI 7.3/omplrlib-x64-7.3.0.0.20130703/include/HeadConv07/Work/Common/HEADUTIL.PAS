{******************************************************************}
{                                                                  }
{   Dr. Bob's Head Converter Combined Console/GUI Version          }
{ 			                                                           }
{ Copyright (C) 1997-2006 Bob Swart (A.K.A. Dr. Bob).   	         }
{                                                                  }
{ Contributor(s): Alan C. Moore (acmdoc@aol.com)                   }
{                 Marcel van Brakel  (brakelm@chello.nl)           }
{                 Michael Beck (mbeck1@zoomtown.com)               }
{                 Bob Cousins (bobcousins34@hotmail.com)           }
{                                                                  }
{                                                                  }
{ Obtained through:                                                }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{                                                                  }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org                }
{ Maintained by the Project JEDI DARTH Team; To join or to report  }
{ bugs, contact Alan C. Moore at acmdoc@aol.com                    }
{                                                                  }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/MPL/MPL-1.1.html                          }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either expressed or }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License.                        }
{                                                                  }
{******************************************************************}


unit HeadUtil;
{$A+,B-,C-,D-,E-,F-,G-,H-,I-,L-,N-,O+,P-,Q-,R-,S-,T-,V-,X-}
interface
uses
  HeadVars;

  procedure Upper(var Str: ShortString);

  procedure ChangeTabs2Spaces(var Str: ShortString);

  procedure ChangeC2Pascal(var Str: ShortString);

  procedure SkipLeadingSpaces(var Str: ShortString);

  procedure SkipTrailingSpaces(var Str: ShortString);

  procedure SkipSpaces(var Str: ShortString);

  procedure SkipVoid(var Str: ShortString);

  procedure FindType(var Line: ShortString; IgnoreLastIfNeeded: Boolean);

  procedure FindConst(var Line: ShortString);

  function Zero2(W: Word): Str02;

implementation

  procedure Upper(var Str: ShortString);
  var
    Len: Byte absolute Str;
    i: Integer;
  begin
    for i:=1 to Len do Str[i] := UpCase(Str[i])
  end {Upper};

  procedure ChangeTabs2Spaces(var Str: ShortString);
  var
    Len: Byte absolute Str;
    i: Integer;
  begin
    for i:=1 to Len do
      if (Str[i] = #9) then Str[i] := #32
  end {ChangeTabs2Spaces};

  procedure ChangeC2Pascal(var Str: ShortString);
  var
    Len: Byte absolute Str;
    i: Integer;
  begin
    i := Pos(' PTR ',Str);
    while i > 0 do { change "PTR" to '*' pointers }
    begin
      Delete(Str,i+1,3);
      Insert('*',Str,i+1);
      i := Pos(' STR ',Str)
    end;
    i := Pos('(*',Str);
    while i > 0 do { remove "C" Pascal-style open comment }
    begin
      Insert(' ',Str,i+1);
      i := Pos('(*',Str)
    end;
    i := Pos('*)',Str);
    while i > 0 do { remove "C" Pascal-style close comment }
    begin
      Insert(' ',Str,i+1);
      i := Pos('*)',Str)
    end
  end {ChangeC2Pascal};

  procedure SkipLeadingSpaces(var Str: ShortString);
  var
    Len: Byte absolute Str;
    i: Integer;
  begin
    i := 1;
    while (i < Len) and (Str[i] <= ' ') do Inc(i);
    if (i > 1) then Str := Copy(Str,i,Len-i+1)
  end;

  procedure SkipTrailingSpaces(var Str: ShortString);
  var
    Len: Byte absolute Str;
  begin
    while (Len > 0) and (Str[Len] <= ' ') do Dec(Len)
  end {SkipTrailing};

  procedure SkipSpaces(var Str: ShortString);
  var
    Len: Byte absolute Str;
    i: Integer;
  begin
    SkipLeadingSpaces(Str);
    SkipTrailingSpaces(Str);
    i := 2;
    while i < Len do
    begin
      if (Str[i] = ' ') and (Str[i-1] = ' ') then Delete(Str,i,1)
      else
        Inc(i)
    end;
    i := 2;
    while i < len do
    begin
      if (Str[i] = '*') and (Str[i-1] = ' ') then Delete(Str,i-1,1)
      else
        Inc(i)
    end
  end {SkipSpaces};

  procedure SkipVoid(var Str: ShortString);
  var
    j,k: Integer;
    Len: Byte absolute Str;
  begin
    for j:=1 to MaxVoid do
    begin
      repeat
        k:=Pos(Void[j],Str);
        if (k > 0) and {!ACM -- String is present }
          ((k = 1) or not (Str[k-1] in IdentSet)) and
          ((Len <= (Length(Void[j])+k)) or
          {!ACM -- Could we declare the set below as a constant for }
          {!ACM -- easier readablity? }
           (Str[k+Length(Void[j])] in [' ','*',';',')'])) then
        begin
          Delete(Str,k,Length(Void[j]));
          if (k > 1) and (Str[k-1] = '_') then Delete(Str,k-1,1);
          SkipSpaces(Str);
          while (Str[Len] = '*') and (Str[Len-1] = ' ') do Delete(Str,Len-1,1)
        end
        else k := 0
      until (k = 0) or (Len = 0)
    end;
    SkipSpaces(Str)
  end {SkipVoid};

  procedure FindType(var Line: ShortString; IgnoreLastIfNeeded: Boolean);
  var
    Len: Byte absolute Line;
    k: Integer;
  begin
    SkipSpaces(Line); { 0.99c }
    if (Len = 0) then { buggy... }
    begin
      write('Integer');
      exit
    end;
    if (Line[Len] = '*') and (Line[Len-1] = ' ') then Delete(Line,Len-1,1);
    k := 0;
    repeat
      Inc(k);
      if (types[k].Ctype <> '') and (Line = types[k].Ctype) then
      begin
        write(types[k].Ptype);
        k := Maxtype+1
      end
    until k >= Maxtype;

    if (k = Maxtype) then { not found in first pass }
    begin
      if (Line[Len] = '*') then
      begin
        Dec(Len);
        if (Line[Len] = '*') and (Line[Len-1] = ' ') then Delete(Line,Len-1,1);
        k := 0;
        repeat
          Inc(k);
          if (types[k].Ctype <> '') and (Line = types[k].Ctype) then
          begin
            if (types[k].Ptype[1] = 'T') then
              write('P',Copy(types[k].Ptype,2,Length(types[k].Ptype)))
            else write('P',types[k].Ptype);
            k := Maxtype+1
          end
        until k >= Maxtype;
        if (k = Maxtype) then write('P',Line) { not found... }
      end
      else
      begin
        if (Line[1] = 'P') or
          ((Line[2] = 'P') and (Line[1] in ['L','N'])) then
        begin
          if Line[1] = 'P' then Delete(Line,1,1)
                           else Delete(Line,1,2);
          k := 0;
          repeat
            Inc(k);
            if (types[k].Ctype <> '') and (Line = types[k].Ctype) then
            begin
              if (types[k].Ptype[1] = 'T') then
                write('P',Copy(types[k].Ptype,2,Length(types[k].Ptype)))
              else write('P',types[k].Ptype);
              k := Maxtype+1
            end
          until k >= Maxtype;
          if (k = Maxtype) then write('P',Line) { not found... }
        end
        else
          if IgnoreLastIfNeeded then
          begin
            k := Len;
            repeat
              Dec(k)
            until (k = 0) or (Line[k] = ' ');
            if (Line[k] = ' ') then
            begin
              Len := k;
              repeat
                Dec(Len)
              until (Len = 0) or (Line[Len] <> ' ');
              if (Len > 0) then FindType(Line,False) { recursive!! }
            end
            else
              write(Line) { not found... }
          end
          else
            write(Line) { not found... }
      end
    end;
  end {FindType};

  procedure FindConst(var Line: ShortString);
  var
    Len: Byte absolute Line;
  begin
    if (Pos('const ',Line) > 0) then
    begin
      write('const ');
      Delete(Line,Pos('const ',Line),5)
    end
    else
    if (Pos('const*',Line) > 0) then
    begin
      write('const ');
      Delete(Line,Pos('const*',Line),5)
    end
    else
    if (Pos('&',Line) > 0) then
    begin
      write('var ');
      Delete(Line,Pos('&',Line),1)
    end;
    SkipSpaces(Line)
  end {FindConst};

  function Zero2(W: Word): Str02;
  const
    X: Array[0..9] of Char = '0123456789';
  begin
    if (W < 10) then Zero2 := '0' + X[W]
    else
      if (W < 100) then
        Zero2 := X[W div 10] + X[W mod 10]
      else
        Zero2 := '00'
  end {Zero2};



end.
