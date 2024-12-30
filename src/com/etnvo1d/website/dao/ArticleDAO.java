package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.Article;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {
    public static List<Article> queryArticleHead(int count, int type) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Article> articleList = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                "select id, title, time, views, cover, content_id from articles where type=? order by time desc limit ?"
            );
            ps.setInt(1, type);
            ps.setInt(2, count);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Article article = new Article();
                article.setId(rs.getInt("id"));
                article.setTitle(rs.getString("title"));
                article.setTime(rs.getDate("time").toLocalDate());
                article.setViews(rs.getInt("views"));
                article.setCover(rs.getString("cover"));
                article.setContentId(rs.getInt("content_id"));
                article.setType(type);
                articleList.add(article);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return articleList;
    }

    public static List<Article> queryArticlesByPage(int page, int type) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Article> articleList = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                "select id, title, time, views, cover, content_id from articles where type=? order by id desc limit ?, 12"
            );
            ps.setInt(1, type);
            ps.setInt(2, (page - 1) * 12);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Article article = new Article();
                article.setId(rs.getInt("id"));
                article.setTitle(rs.getString("title"));
                article.setTime(rs.getDate("time").toLocalDate());
                article.setViews(rs.getInt("views"));
                article.setCover(rs.getString("cover"));
                article.setContentId(rs.getInt("content_id"));
                article.setType(type);
                article.setContent(ContentDAO.query(article.getContentId()));
                articleList.add(article);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return articleList;
    }

    public static int countArticles(int type) {
        Connection con = ConnectionPool.getInstance().getConnection();
        int count = 0;
        try {
            PreparedStatement ps = con.prepareStatement(
                "select count(*) as pages from articles where type=?"
            );
            ps.setInt(1, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("pages");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return count;
    }

    public static Article getArticleDetail(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                "select title, time, views, cover, content_id, type from articles where id=?"
            );
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Article article = new Article();
                article.setId(id);
                article.setTitle(rs.getString("title"));
                article.setTime(rs.getDate("time").toLocalDate());
                article.setViews(rs.getInt("views"));
                article.setCover(rs.getString("cover"));
                article.setContentId(rs.getInt("content_id"));
                article.setType(rs.getInt("type"));
                article.setContent(ContentDAO.query(article.getContentId()));
                return article;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return null;
    }

    public static void insert(String title, String cover, int content_id, int type) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("insert into articles (title, cover, content_id, type, time, views) values (?, ?, ?, ?, now(), 0)"
            );
            ps.setString(1, title);
            ps.setString(2, cover);
            ps.setInt(3, content_id);
            ps.setInt(4, type);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void update(int id, String title, int content_id, int type) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("update articles set title=?, content_id=?, type=? where id=?");
            ps.setString(1, title);
            ps.setInt(2, content_id);
            ps.setInt(3, type);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void update(int id, String title, String cover, int content_id, int type) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("update articles set title=?, cover=?, content_id=?, type=? where id=?");
            ps.setString(1, title);
            ps.setString(2, cover);
            ps.setInt(3, content_id);
            ps.setInt(4, type);
            ps.setInt(5, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void remove(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("delete from articles where id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void addView(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("update articles set views=views+1 where id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }
}
