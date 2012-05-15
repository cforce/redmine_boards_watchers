redmine_boards_watchers
=======================

Inspired by http://www.redmine.org/plugins/redmine_boards_watchers

------------------------------
Redmine boards watchers and sticky groups plugin
Priority for sticky messages

Plugin adds ability to select priority level for sticky messages. Messages sorted by level first and modification time second
Please do plugins migrations before use!
Boards and topics watchers management

Plugin allows to add/remove watchers to the project' forums and their individual topics. Also it allows to assign watchers while creating a message.

Watchers management screen allows to add group members to watchers as well as lookup and quickly select watchers by typing part of his name

Plugin adds following extra links/forms

    Extra button Watchers in Settings->Forums tab for each board right before Edit and Delete
    Extra column Watchers in list of forums
    Extra column Watchers in list of topics for each forum
    Watchers management screen for new message form

Number of watchers is displayed in parenthesis after the watchers' icon.

To enable this feature you should have following permissions enabled for role:

    Manage board watchers (Boards section of permissions dialog) - enable if you want to allow boards watchers management
    Manage topic watchers (Boards section of permissions dialog) - enable if you want to allow individual topics watchers management
    Add watchers (Issue tracking section of permissions dialog) - should be enabled for both (board/topic) modes to work
    Delete watchers (Issue tracking section of permissions dialog) - should be enabled for both (board/topic) modes to work

Patches and changed views

Following views are altered:

    boards/index.html.erb
    boards/show.html.erb
    messages/_form.html.erb
    projects/_form.html.erb
    projects/settings/_boards.html.erb

Following controllers/models are patched

    boards_controller (show)
    messages_controller (new,edit)
    message (sticky_priority attribute)

Installation notes

    Please do run plugin migrations before usage

