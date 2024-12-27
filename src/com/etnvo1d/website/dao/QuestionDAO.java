package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.Question;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {
    public static List<Question> queryQuestionHead(int count) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Question> questionList = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select q.id, q.title, q.author, q.time, u.name from questions q join users u on q.author = u.id order by q.time desc limit ?"
            );
            ps.setInt(1, count);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setTitle(rs.getString("title"));
                question.setAuthorId(rs.getString("author"));
                question.setAuthorName(rs.getString("name"));
                question.setTime(rs.getDate("time").toLocalDate());
                questionList.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return questionList;
    }
}
