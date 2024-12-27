package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public static User queryUser(String id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        User user = null;
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select name, type, password from users where id = ?"
            );
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(id);
                user.setName(rs.getString("name"));
                user.setType(rs.getInt("type"));
                user.setPassword(rs.getString("password"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return user;
    }
}
