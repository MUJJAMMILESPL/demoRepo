public class ProjectCalloutServiceMock implements HttpCalloutMock {
   //Implement http mock callout here
   public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse resp = new HTTPResponse();
        System.assert(req.getMethod() == 'POST');
        System.assert(String.isNotBlank(req.getBody()));

        resp.setStatusCode(201);
        resp.setBody('Created');
        return resp;
   }
}