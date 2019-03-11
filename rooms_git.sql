create table rooms_git (
  room_key number primary key,
  name varchar2(100) not null
);

create table room_contents_git (
  contents_key number primary key,
  room_key number not null,
  name varchar2(100) not null,
  create_date timestamp default current_timestamp not null,
  constraint fk_rooms_git foreign key (room_key) references rooms (room_key)
);
/

create or replace package test_rooms_management_git is

  gc_null_value_exception constant integer := -1400;
  --%suite(Rooms management)
  
  --%beforeall
  procedure setup_rooms;

  
  --%context(remove_rooms_by_name)
  --%displayname(Remove rooms by name)
  
    --%test(Removes a room without content in it)
    procedure remove_empty_room;

    --%test(Raises exception when null room name given)
    --%throws(-6501)
    procedure null_room_name;  

  --%endcontext
  
  --%context(add_rooms_content)
  --%displayname(Add content to a room)

    --%test(Fails when room name is not valid)
    --%throws(no_data_found)
    procedure fails_on_room_name_invalid;

   /* --%test(Fails when content name is null)
    --%throws(gc_null_value_exception)
    procedure fails_on_content_null; */

    --%test(Adds a content to existing room)
    procedure add_content_success;

  --%endcontext
end;
/

create or replace package body test_rooms_management_git is

  procedure setup_rooms is
  begin
    insert all
      into rooms values(1, 'Dining Room')
      into rooms values(2, 'Living Room')
      into rooms values(3, 'Bathroom')
    select 1 from dual;

    insert all
      into room_contents values(1, 1, 'Table', sysdate)
      into room_contents values(3, 1, 'Chair', sysdate)
      into room_contents values(4, 2, 'Sofa', sysdate)
      into room_contents values(5, 2, 'Lamp', sysdate)
    select 1 from dual;

    dbms_output.put_line('---SETUP_ROOMS invoked ---');
  end;

  procedure remove_empty_room is
    l_rooms_not_named_b sys_refcursor;
    l_remaining_rooms   sys_refcursor;
  begin
    open l_rooms_not_named_b for select * from rooms where name not like 'B%';

    rooms_management.remove_rooms_by_name('B%');

    open l_remaining_rooms for select * from rooms;
    ut.expect( l_remaining_rooms ).to_equal(l_rooms_not_named_b);
  end;

  procedure room_with_content is
  begin
    rooms_management.remove_rooms_by_name('Living Room');
  end;

  procedure null_room_name is
  begin
    rooms_management.remove_rooms_by_name(NULL);
  end;

  procedure fails_on_room_name_invalid is
  begin
    rooms_management.add_rooms_content('bad room name','Chair');
  end;

  procedure fails_on_content_null is
  begin
    --Act
    rooms_management.add_rooms_content('Dining Room',null);
    --Assert done by --%throws annotation
  end;

  procedure add_content_success is
    l_expected        room_contents.name%type;
    l_actual          room_contents.name%type;
  begin
    --Arrange
    l_expected := 'Table';

    --Act
    rooms_management.add_rooms_content( 'Dining Room', l_expected );
    --Assert
    select name into l_actual from room_contents
     where contents_key = (select max(contents_key) from room_contents);

    ut.expect( l_actual ).to_equal( l_expected );
  end;  
end;
/
