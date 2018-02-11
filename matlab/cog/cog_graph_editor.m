% ----------------------------------------------------------------------
% This code is developed as part of the Java CoG Kit project
% The terms of the license can be found at http://www.cogkit.org/license
% This message may not be removed or altered.
% ----------------------------------------------------------------------

function result = cog_graph_editor(varargin)
%
% Matlab wrapper around the CoG kit 'graph-editor' script
%
% Usage:
%   graph-editor [options]
%     -s <port>
%       Starts the service on the specified port. If no port is
%       specified, 9999 is used.
%     -h | -help
%       Displays this help message and exits.
%     -l | -load <file>
%       specifies a file to be loaded on startup
%     -t | -target <target>
%       Starts on the specified target. If missing, the default target
%       (the Swing GUI) will be used
%     -q | -quit
%       Render the graph and quit. Useful with non-interactive targets.
%       This is the default when the -load option is used. In server
%       mode, the program will wait for a graph first, render it and then
%       quit.
%     -r | -loop
%       In server mode loop and wait for updates, and render them, as
%       opposed to quitting after the graph is received.
%     -o | -options <options>
%       Pass additional options to various sub-components. The value must
%       be quoted and has the form [property=value[,
%       property=value[,...]]]. Take a look at etc/grapheditor.properties
%       for a list of properties.


% Command to be executed is the graph-editor batch/script file.
strCommand = 'graph-editor';

% Run the globuswrapper script using the given command and user-supplied arguments
globuswrapper(strCommand,varargin);
