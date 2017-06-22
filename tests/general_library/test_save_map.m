function test_save_map()
    init_lib(); %Initialize the library, clearing the screen, etc.
    S.c = 4.124;
    S.myval = 'A string2';
    S.a = 43.112312;
    S.format_a = '%0.1f';
    save_map_to_csv(S, 'test_map.csv');
end