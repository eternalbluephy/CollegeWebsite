<%@ page import="java.util.Map" %>
<%@ page import="java.net.http.HttpClient" %>
<%@ page import="java.net.http.HttpRequest" %>
<%@ page import="java.net.URI" %>
<%@ page import="java.net.http.HttpResponse" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.databind.JsonNode" %>
<%@ page import="com.etnvo1d.website.util.CookieUtil" %><%--<script>--%>
<%--    document.addEventListener('DOMContentLoaded', function() {--%>
<%--        const token = localStorage.getItem('jwt_token');--%>
<%--        if (!token) return;--%>

<%--        $.ajax({--%>
<%--            url: '/api/auth',--%>
<%--            type: 'GET',--%>
<%--            headers: {--%>
<%--                'Authorization': 'Bearer ' + token--%>
<%--            },--%>
<%--            success: function(response) {--%>
<%--                if (!response.success) {--%>
<%--                    localStorage.removeItem('jwt_token');--%>
<%--                    alert(response.message)--%>
<%--                }--%>
<%--            },--%>
<%--            error: function() {--%>
<%--                localStorage.removeItem('jwt_token');--%>
<%--                alert('登录出错，请重试')--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>
<%--</script>--%>

<%
    session.setAttribute("login", false);
    session.setAttribute("uid", 0);
    session.setAttribute("type", 0);

    HttpClient client = HttpClient.newHttpClient();
    HttpRequest authRequest = HttpRequest.newBuilder()
            .uri(URI.create(basePath + "api/auth"))
            .setHeader("Cookie", CookieUtil.toString(request.getCookies()))
            .build();
    try {
        HttpResponse<String> authResponse = client.send(authRequest,
                HttpResponse.BodyHandlers.ofString());
        if (authResponse.statusCode() == 200) {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(authResponse.body());
            boolean success = jsonNode.get("success").asBoolean();
            System.out.println(success);
            if (success) {
                session.setAttribute("login", true);
                session.setAttribute("uid", jsonNode.get("uid").asText());
                session.setAttribute("type", jsonNode.get("type").asInt());
            }
        }
    } catch (InterruptedException e) {
        throw new RuntimeException(e);
    }

%>