package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public static User queryUser(String id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        User user = null;
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select name, type, password, money from users where id = ?"
            );
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(id);
                user.setName(rs.getString("name"));
                user.setType(rs.getInt("type"));
                user.setPassword(rs.getString("password"));
                user.setMoney(rs.getDouble("money"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return user;
    }

    public static List<User> queryUsersByPage(int page) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<User> users = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select id, name, type, password, money from users where type = 0 limit ?, 12"
            );
            ps.setInt(1, (page - 1) * 12);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getString("id"));
                user.setName(rs.getString("name"));
                user.setType(rs.getInt("type"));
                user.setPassword(rs.getString("password"));
                user.setMoney(rs.getDouble("money"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return users;
    }

    public static void insert(String id, String name, String encryptedPassword) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("insert into users(id, name, password, type) values(?, ?, ?, 0)");
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, encryptedPassword);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void update(String id, String name, String encryptedPassword) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("update users set name=?, password=? where id=?");
            ps.setString(1, name);
            ps.setString(2, encryptedPassword);
            ps.setString(3, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void update(String id, String name) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("update users set name=? where id=?");
            ps.setString(1, name);
            ps.setString(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void remove(String id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("delete from users where id=?");
            ps.setString(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static int countUsers() {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("select count(*) as cnt from users");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return 0;
    }
}
