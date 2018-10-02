function str = randHopefulMsg()
    
    nr_msgs = 7;
    msg = cell(nr_msgs);

    msg{1} = 'Hang in there!';
    msg{2} = 'Almost done!';
    msg{3} = 'Almost there!';
    msg{4} = 'Don''t go anywhere!';
    msg{5} = 'Just about done!';
    msg{6} = 'Just one more second. Well, not one, but you know, soon!';
    msg{7} = 'Soon!';


    i = randi([1, nr_msgs]);
    str = msg{i};
