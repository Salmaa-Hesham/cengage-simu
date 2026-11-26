package com.cengage.library.model;

public class UserSubscription {
    private int userId;
    private String username;
    private String fullName;
    private String institution; // e.g. "MIT", "Stanford University"
    private String planName;    // e.g. "Cengage Unlimited - All Access"
    private boolean active;
    private int lastReadPublicationId;

    public UserSubscription() {}

    public UserSubscription(int userId, String username, String fullName, 
                            String institution, String planName, boolean active, 
                            int lastReadPublicationId) {
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.institution = institution;
        this.planName = planName;
        this.active = active;
        this.lastReadPublicationId = lastReadPublicationId;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getInstitution() { return institution; }
    public void setInstitution(String institution) { this.institution = institution; }

    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public int getLastReadPublicationId() { return lastReadPublicationId; }
    public void setLastReadPublicationId(int lastReadPublicationId) { this.lastReadPublicationId = lastReadPublicationId; }
}