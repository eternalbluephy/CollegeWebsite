<script>
    document.addEventListener('DOMContentLoaded', function() {
        const token = localStorage.getItem('jwt_token');

        $.ajax({
            url: '/api/auth.jsp',  // 更改为新的API端点
            type: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token
            },
            success: function(response) {
                if (!response.success) {
                    localStorage.removeItem('jwt_token');
                }
            },
            error: function() {
                localStorage.removeItem('jwt_token');
            }
        });
    });
</script>