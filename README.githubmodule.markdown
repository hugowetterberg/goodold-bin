Githubmodule
==============================

This is a helper script for adding projects from github as submodules. It's written with drupal modules in mind (the default path for submodules is sites/default/modules) but works equally well for other kind of projects.

The script has two modes: command-line and interactive. Interactive mode is triggered by the -i / -interactive flag or by calling "githubmodule" without any parameters. If command other command line arguments are used in combination with -interactive they will be used as a starting point for the interactive session.

Command line usage
--------------------

At it simplest you use githubmodule to add your own repos as submodules. If I have a repo named oauth_common (http://github.com/hugowetterberg/oauth_common) that I want to add I type the following:

    $ githubmodule oauth_common

The repo is then registered as a submodule in sites/default/modules/oauth_common. Adding several submodules is just as easy:

    $ githubmodule oauth_common services_oauth

### Specifying the github user

The repos you want to add might not always be your own, then you can use the user (or u) parameter:

    $ githubmodule u=hugowetterberg oauth_common services_oauth

### Changing submodule location

The following parameter registers the submodule in sites/all/modules instead of the default location:

    $ githubmodule oauth_common in=sites/all/modules

The location is set for all the submodules you're adding.

### Aliasing the submodule

The repo doesn't always have the name that you want to check it out as. To alias a submodule, use the following parameter:

    $ githubmodule drupal-oembed as=oembed

You can alias several submodules like this:

    $ githubmodule oauth_common as=my_oauth_common services_oauth as my_services_oauth

The principle is that the alias parameter applies to the previous project.

### Checking out using private url

The default behaviour is to check out the modules using the public/read only url. To change this, just use the -p / -priv / -private flag. This flag applies to all the submodules you're adding.

    $ githubmodule -private oauth_common services_oauth

Interactive usage
-----------------

When you start a interactive session you'll get a list with our github projects. In my case:

    1. cobalt                2. flickr_context_tags   3. gtranslate            
    4. simple_geo            5. datapoint             6. imagecache_action_... 
    7. nodeformcols          8. jsonrpc_server        9. biurnal               
    10. services             11. rest_server          12. services_oauth       
    13. goodold_drupal       14. githook              15. oauth_common         
    16. snippet_slide_xml    17. query_builder        18. comment_resource     
    19. services_oop         20. flag_service         21. tm_green_moleskin... 
    22. goodold-tmbundle     23. content_license      24. custom_path_themes   
    25. drupal-oembed        26. Neopro.tmTheme       27. svpt-vs-swtw         
    28. Drupalcamp-Twitte... 29. inputstream          30. goodold-bin          
    31. emo-vote             32. drupal-notifier      33. dissue

When you add, remove or do other stuff with these projects you can reference them using either their number or their name. You can also use partial matching like <code>diss*</code> to match the project.

The help text that you get in interactive mode when writing help:

    'add [project reference]' - to add a project.
    'alias [project reference] some_name' - to check out the project under a different name.
    'in [new path]' - to change where the submodules are placed.
    'remove [project reference]' - to remove a project.
    'list' - to list the available projects, 'list active' to show added projects.
    'help' - to show this help text.
    'quit' - to cancel.
    'show [project reference]' - to show more info about the project.
    'done' - to finish and add the submodules.

    Project refences can be either the project number or the name ofthe project. 
    You can also end the project name with a * wildcard to perform
    partial matching.

    Commands can be shortened arbitrarily and will be matched to the first command
    that matches. The command 'a' will map to 'add', not 'alias', as 'add' comes
    before 'alias' in the command list. Therefore the shortest possible form for
    'alias' is 'al'.