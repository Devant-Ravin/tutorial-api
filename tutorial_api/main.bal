import ballerina/http;
import ballerina/lang.value;
import ballerina/time;

listener http:Listener Service1 = new (port = 9095);

service / on Service1 {
    resource function get hello() returns http:InternalServerError|string|error {
        do {

            return "Received";
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }
}

listener http:Listener Service2 = new (port = 9091);

service /base on Service2 {
    resource function get greeting() returns error|json|http:InternalServerError {
        do {
            time:Utc past = time:utcNow();
            string var1 = check service1->get("/hello");
            time:Utc current = time:utcNow();
            time:Seconds timeSeconds = time:utcDiffSeconds(past, current);
            string var2;
            string stringResult = value:toString(timeSeconds);

            return stringResult;
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }
}
