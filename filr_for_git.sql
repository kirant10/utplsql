create or replace function betwnstrgit( a_string varchar2, a_start_pos integer, a_end_pos integer ) return varchar2 is
  l_start_pos pls_integer := a_start_pos;
begin
  if l_start_pos = 0 then
    l_start_pos := 1;
  end if;
  return substr( a_string, l_start_pos, a_end_pos - l_start_pos +1 );
end;
/

create or replace package test_betwnstr_git as

  -- %suite(Between string function)

  -- %test(Returns substring from start position to end position)
  procedure basic_usage;
  
  -- %test(Returns substring from start, when start position is zero)   
  procedure zero_start_position;
  
  -- %test(Returns string until end if end position is greater than string length)
  procedure big_end_position;
  
   -- %test(Returns null for null input string value)
  procedure null_string;

  -- %test(A demo of test raising runtime exception)
  procedure bad_params;

  -- %test(A demo of failing test)
  procedure bad_test;    

/*  -- %test(Demo of a disabled test)
  -- %disabled
  procedure disabled_test;
*/
 
end;
/
  
create or replace package body test_betwnstr_git as

  procedure basic_usage is
  
  begin
    ut.expect( betwnstr( '1234567', 2, 5 ) ).to_equal('2345');
  end;
  
  procedure zero_start_position is
  
  begin
    ut.expect( betwnstr( '1234567', 0, 5 ) ).to_( equal('12345') );
  end;
  
   procedure big_end_position is
  begin
    ut.expect( betwnstr( '1234567', 0, 500 ) ).to_( equal('1234567') );
  end;

  procedure null_string is
  begin
    ut.expect( betwnstr( null, 2, 5 ) ).to_( be_null() );
  end;

  procedure bad_params is
  begin
    ut.expect( betwnstr( '1234567', 'a', 'b' ) ).to_( be_null() );
  end;

  procedure bad_test is
  begin
    ut.expect( betwnstr( '1234567', 0, 500 ) ).to_( equal('1') );
  end;

  procedure disabled_test is
  begin
    ut.expect( betwnstr( null, null ) ).not_to( be_null );
  end;
  
end;
  /
