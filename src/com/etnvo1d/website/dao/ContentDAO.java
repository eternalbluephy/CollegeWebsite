package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.Article;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ContentDAO {
    public static String query(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select content from content where id=?"
            );
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("content");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return null;
    }

    public static int getMaxId() {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("select max(id) from content");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return 0;
    }

    public static int upsert(Integer id, String content) {
        boolean insert = id == null || id == 0 || query(id) == null;
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps;
            if (insert) {
                ps = con.prepareStatement("insert into content (content) values (?)", PreparedStatement.RETURN_GENERATED_KEYS);
                ps.setString(1, content);
            } else {
                ps = con.prepareStatement("update content set content = ? where id = ?");
                ps.setString(1, content);
                ps.setInt(2, id);
            }
            ps.executeUpdate();
            if (insert) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return id;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return 0;
    }
}
