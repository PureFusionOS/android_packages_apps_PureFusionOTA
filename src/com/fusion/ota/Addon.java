package com.fusion.ota;

public class Addon {

    private String mTitle;
    private String mDesc;
    private String mPublishedAt;
    private int mFilesize;
    private String mDownloadLink;
    private int mId;

    public String getTitle() {
        return mTitle;
    }

    public void setTitle(String input) {
        mTitle = input;
    }

    public String getDesc() {
        return mDesc;
    }

    public void setDesc(String input) {
        mDesc = input;
    }

    public String getPublishedAt() {
        return mPublishedAt;
    }

    public void setPublishedAt(String input) {
        mPublishedAt = input;
    }

    public String getDownloadLink() {
        return mDownloadLink;
    }

    public void setDownloadLink(String input) {
        mDownloadLink = input;
    }

    public int getFilesize() {
        return mFilesize;
    }

    public void setFilesize(int input) {
        mFilesize = input;
    }

    public int getId() {
        return mId;
    }

    public void setId(int input) {
        mId = input;
    }
}
