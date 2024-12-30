package com.etnvo1d.website.entity;

public class User {
    public static class Type {
        public static final int Common = 0;
        public static final int Admin = 1;
    }

    private String id;
    private String name;
    private int type;
    private String password;
    private double money;

    public User() {}

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public double getMoney() {
        return money;
    }

    public void setMoney(double money) {
        this.money = money;
    }
}
