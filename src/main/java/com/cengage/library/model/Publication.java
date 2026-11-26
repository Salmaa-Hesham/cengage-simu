package com.cengage.library.model;

public class Publication {
    private int id;
    private String title;
    private String author;
    private String type; // TEXTBOOK, NEWSPAPER, RESEARCH_PAPER
    private String category;
    private String isbn;
    private String summary;
    private String content;
    private String coverUrl;

    public Publication() {}

    public Publication(int id, String title, String author, String type, 
                       String category, String isbn, String summary, 
                       String content, String coverUrl) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.type = type;
        this.category = category;
        this.isbn = isbn;
        this.summary = summary;
        this.content = content;
        this.coverUrl = coverUrl;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getCoverUrl() { return coverUrl; }
    public void setCoverUrl(String coverUrl) { this.coverUrl = coverUrl; }
}