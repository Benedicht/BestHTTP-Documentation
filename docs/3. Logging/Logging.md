#Logging
To be able to dump out some important - and sometimes less important - functioning of the plugin a logger interface and implementation is introduced in v1.7.0. The default logger can be accessed through the HTTPManager.Logger property. The default loglevel is Warning for debug builds and Error for others.
The default logger implementation uses Unity’s Debug.Log/LogWarning/LogError functions.
A new logger can be written by implementing the ILogger interface from the BestHTTP.Logger namespace.
