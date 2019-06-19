#Set the default Json encoder
You can change the default Json encoder by setting the SocketManager’s static DefaultEncoder to a new encoder. After this step all newly created SocketManager will use this encoder.
Or you can set directly the SocketManager object’s Encoder property to an encoder.
