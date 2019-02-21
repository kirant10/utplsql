create or replace package body test_animals_getter is

    procedure test_variant_get_animal is
    begin
      --Act / Assert
      ut.expect( get_animal() ).to_( equal( 'a dog' ) );
    end;

   procedure test_variant_1_get_animal is
    begin
      --Act / Assert
      ut.expect( get_animal() ).to_( equal( 'a dog', a_nulls_are_equal => true ) );
    end;

    
  procedure test_be_between is
    begin
        ut.expect( 3 ).to_be_between( 1, 3 );
    end;
    
   procedure test_to_be_false is
    begin
      ut.expect( ( 1 = 0 ) ).to_be_false();
    end;

   procedure to_be_greater_or_equal is
   begin
     ut.expect( sysdate ).to_be_greater_or_equal( sysdate - 1 );
   end;

  procedure to_be_greater_than is
   begin
     ut.expect( 2 ).to_be_greater_than( 1 );
  end;
 
  procedure to_be_less_or_equal is
  begin
    ut.expect( 3 ).to_be_less_or_equal( 3 );
  end;

  procedure to_be_less_than is
  begin
     ut.expect( 3 ).to_be_less_than( 2 );
  end;

  procedure to_be_like is
  begin
   ut.expect( 'Lorem_impsum' ).to_be_like( '%rem#_%', '#' );
  end;


procedure to_be_not_null is
begin 
  ut.expect( to_clob('ABC') ).to_be_not_null();
  --or 
  ut.expect( to_clob('ABC') ).to_( be_not_null() );
  --or 
  ut.expect( to_clob('ABC') ).not_to( be_null() );
end;


  procedure to_be_null is
  begin
   ut.expect( cast(null as varchar2(100)) ).to_be_null();
 end;    
 

   procedure to_be_true is
  begin 
    ut.expect( ( 1 = 1 ) ).to_be_true();
  end;


   procedure test_if_cursor_is_empty is
    l_cursor sys_refcursor;
   begin
       open l_cursor for select * from dual connect by level <=10;
    ut.expect( l_cursor ).to_have_count(10);
   end;
   
   procedure match is
     begin 
     ut.expect( a_actual => '123-456-ABcd' ).to_match( a_pattern => '\d{3}-\d{3}-[a-z]', a_modifiers => 'i' );
       ut.expect( 'some value' ).to_match( '^some.*' );
     end;    

end;
/


