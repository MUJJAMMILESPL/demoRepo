public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here
   public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse resp = new HTTPResponse();
        System.assert(req.getMethod() == 'POST');
        System.assert(String.isNotBlank(req.getBody()));

        resp.setStatusCode(400);
        resp.setBody('Not Created');
        return resp;
   }
}