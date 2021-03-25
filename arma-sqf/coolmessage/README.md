<h3>Cool Message</h3>
<p>A simple function for displaying fading messages in-game.</p>

<p>
Place the coolmessage.sqf into your Arma script folder and in your main.sqf add and compile the file via:

<code>call compileFinal preprocessFile "coolmessage.sqf";</code>
</p>

<p>
Now you're ready to use the function in any subsequence functions/files.

If you are showing the message only to a local client you can call it via:

<code>"Hello <t color='#f0f0f0'>World</t>" call func_pxCoolMsg;</code>

and if you'd like to show the message globally to all players:

<code>"Hello <t color='#f0f0f0'>World</t>" call func_pxSendCoolMsg;</code>
</p>
