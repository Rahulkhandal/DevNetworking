# DevNetworking

This library is simple, extensible module to execute network calls and parse response.

# Main Features

Pure Swift
Protocol Oriented implementation
Simple Apis
Unit test coverage
Extendable library

# Uses

Actions - Used as middleware to intercept request and response
Network Error - Different network cases handling like 200, 401 ...
Network Module - It does network call with dependencies requestBuilder and UrlSession
Network Request - Different end point need to adhere this protocol to make request
Network Response - Network response data
Queue Executor - By default response of any network call pass on main queue, but module has functionality to modify this using queueExecutorType param
RequestBuilder - Building request with base URL

