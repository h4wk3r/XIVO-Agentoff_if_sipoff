# XIVO-Agentoff_if_sipoff ( Wazo )

Automatically Disconnect an Agent if his SIP Account is Inactive.

Posted on Thu 29 October 2015 in XiVO/Wazo IPBX by Nicolas Vdb.
(http://blog.wazo.community/automatically-disconnect-an-agent-if-inactive.html)


Hello, my name is Nicolas (h4wk3r on irc #Wazo). I am a currently alternating between my studies for a Master in Computer Engineering and my work in a call center. I could not find any information in the XiVO CTI when a phone was disconnected, so I worked on a solution for generating this information. This allows agents to know their phone's status.

Let us imagine the following scenario: An agent in a call center is connected with is softphone 'N. SIP XXX'. He logs in via his XiVO Client in order to receive calls from his assigned queues. One of the following 3 events occurs :

> A:  The softphone is disconnected from asterisk . 

> B: The agent finishes his day, turns off his softphone but forgets to disconnect his XiVO Client.

> C: The agent is at home, the VPN tunnel stops.

In these 3 examples, the agent cannot know if he can still recieve calls because he does not recieve any alerts from his XiVO client or from the phone.

- I. Standard operation

Agent's point of view

* ![alt text](http://blog.wazo.community/public/agent_disconnect/photo1.png)

Point of view on the XiVO Server

* ![alt text](http://blog.wazo.community/public/agent_disconnect/photo2.png)

- II. Anomaly

Agent's point of view

Let us simulate the anomaly. For this simulation, the softphone has been forcefully disconnected.

* ![alt text](http://blog.wazo.community/public/agent_disconnect/photo3.png)

We can see that our agent is still logged in and no other information about the disconnection is displayed

Point of view on the XiVO Server

* ![alt text](http://blog.wazo.community/public/agent_disconnect/photo4.png)

We can see that the state of extension 741 is UNKNOWN, but agent 6002 (extension 728) is still connected.

- III. Execution of the script

The script will find out that the SIP account is disconnected and will automatically log out the agent associated to the extension.

* ![alt text](http://blog.wazo.community/public/agent_disconnect/photo5.png)

Accordingly, the agent now knows that he is logged out:

* ![alt text](http://blog.wazo.community/public/agent_disconnect/photo6.png)
