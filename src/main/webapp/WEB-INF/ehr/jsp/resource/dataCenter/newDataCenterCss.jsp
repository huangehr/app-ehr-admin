<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<style>
    #contentPage{
        padding: 0!important;
        overflow: auto;
    }
    .charts{
        position:relative;
        border:none !important;
    }
    body{
        background: none;
    }
    .pd-l-0{
        padding-left: 0;
    }
    .pd-r-0{
        padding-right: 0;
    }
    .pd-b-0{
        padding-bottom: 0;
    }
    .pd-b-15{
        padding-bottom: 15px;
    }
    .pd-l-15{
        padding-left: 15px;
    }
    .mg-b-0{
        margin-bottom: 0!important;
    }
    .mg-0{
        margin: 0;
    }
    .f-l{
        float: left;
    }
    .f-r{
        float: right;
    }
    .hr-c-top{
        /*margin-bottom: 15px;*/
        font-size: 0;
    }
    .hr-chart-top{
        display: inline-block;
        color: #323232;
        font-size: 12px;
        vertical-align: middle;
    }
    .hr-chart-top .charts{
        background: #fff;
    }
    .hr-tit-con{
        height: 61px;
        font-size: 14px;
        font-weight: 600;
        padding: 22px 0 22px 28px;
    }
    .c-title{
        padding-left: 20px;
        border-left: 4px solid #30a9de;
    }
    .hr-chart{
        height: 40vh;
    }
    .hr-body{
        min-height: 100%;
        background: #e9f2f8;
        padding-top: calc(120px + 45px);
    }
    .tmp-top{
        /*padding: 15px;*/
        position: absolute;
        left: 0;
        top: 0;
        right: 0;
        z-index: 5;
        border-bottom: 1px solid #f0f0f0;
    }
    .top-list{
        background: #fff;
        text-align: center;
        font-size: 0;
        padding: 15px 0;
    }
    .tmp-top-item{
        height: 120px;
        display: inline-block;
        width: 23.5%;
        margin: 0 7px;
        background: #ccc;
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
        color: #fff;
        position: relative;
    }
    a.tmp-top-item:hover{
        color: #fff;
    }
    .tmp-tit{
        font-size: 16px;
        padding: 25px 0 20px 0;
    }
    .tmp-num{
        font-size: 30px;
    }
    .tmp-tit,.tmp-num{
        text-align: left;
        padding-left: 32px;
    }
    .tm-one{
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAYYAAACCCAYAAABCZm9HAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpBNjE1RDgzNEYwRkUxMUU3QkU3ODk2OTNCQkU0RDM5MyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpBNjE1RDgzNUYwRkUxMUU3QkU3ODk2OTNCQkU0RDM5MyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkE2MTVEODMyRjBGRTExRTdCRTc4OTY5M0JCRTREMzkzIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkE2MTVEODMzRjBGRTExRTdCRTc4OTY5M0JCRTREMzkzIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+xkTCrAAACNNJREFUeNrs3cly29gV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);
    }
    .tm-two{
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAYYAAACCCAYAAABCZm9HAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpCRTNFQkNGM0YwRkUxMUU3QkFBM0RFMjlDM0RDRjRBMSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpCRTNFQkNGNEYwRkUxMUU3QkFBM0RFMjlDM0RDRjRBMSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkJFM0VCQ0YxRjBGRTExRTdCQUEzREUyOUMzRENGNEExIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkJFM0VCQ0YyRjBGRTExRTdCQUEzREUyOUMzRENGNEExIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+vR+ObQAABv9JREFUeNrs3ctyG0UU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);
    }
    .tm-three{
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAYYAAACCCAYAAABCZm9HAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpEMDU3Qjk1QUYwRkUxMUU3QTRDQUYzRDU0MjYwOTJCOCIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpEMDU3Qjk1QkYwRkUxMUU3QTRDQUYzRDU0MjYwOTJCOCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkQwNTdCOTU4RjBGRTExRTdBNENBRjNENTQyNjA5MkI4IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkQwNTdCOTU5RjBGRTExRTdBNENBRjNENTQyNjA5MkI4Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+o5I8vgAAB3ZJREFUeNrs3ctyG8cV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);
    }
    .tm-four{
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAYYAAACCCAYAAABCZm9HAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpFMUI4RkJEMEYwRkUxMUU3OEVEOEY2MUY1QUY5NzFGQyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpFMUI4RkJEMUYwRkUxMUU3OEVEOEY2MUY1QUY5NzFGQyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkUxQjhGQkNFRjBGRTExRTc4RUQ4RjYxRjVBRjk3MUZDIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkUxQjhGQkNGRjBGRTExRTc4RUQ4RjYxRjVBRjk3MUZDIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+S51aiAAAB2VJREFUeNrs3ct229YVBmDcqEvqvE3yAJ2n7bMk03TYTps+S915xl3Ok3TaZNUSLyj2OQckbdG1bFMkSHzfCsSLvLJECDo/9rkA9Zu//7sq/jBs3w/bt8P2qgJgDn4dtjfD9rdh+2e80ZRv/GXY/jFsvxcKALPyqrT9r0sWVN2wfTdsP9o3ALMXWfCvqBh+sC8AKL6PYPjGfgCg+CaC4Wv7AYDi68Y+AGCfYABAMAAgGAAQDAAIBgAEAwCCAQDBAIBgAEAwACAYABAMAAgGAAQDAIIBAMEAgGAAQDAAIBgAEAwAIBgAEAwACAYABAMAggEAwQCAYABAMAAgGAAQDAAIBgAEAwCCAQDBAIBgAEAwACAYABAMAAgGAAQDAAgGAAQDAIIBAMEAgGAAQDAAIBgAEAwACAYABAMAggEAwQCAYABAMAAgGAAQDAAIBgAEAwCCAQDBAACCAQDBAIBgAEAwACAYABAMALyEzi6Aaarr+DI+H5/kbXz5//R9fNl/I/7r83t9+T4IBjhzY9/mRr5uSgPf1KmR375OL8rrExjDo9/kF/1eaPSbfvu9Pr63eS9oEAzAc1r+qmqisY8AaEuj35YAmGDH7ViV5J+tfvphDgXJJodGDozyfL17D8EAsz77b6LxH7ZmbPzbK//MkRUl9A4GyFhhDCGxice10BAMcK0N4nBG3XQlBLpdNcDTImOslpr3QiNVF+tSaQyPm/XuNYIBLiMIFnWqCHIg2CfHqDbqrn5SZYyBsQ2KVTU8N5ghGGACZ7oRAO1CEJwrMJpuLzD6HA7RDRWPm1UODQQDnKQqGMOg0jU0uaCOFqotv5htZREVxSoqi96UW8EAxwmD9qbO3USdJLj0yiJVFKu+VBW5wkAwwLMalGYIgxQIwuC6frftEPRtvasqNiUoVoJCMMABqZvoJncV6SaaV0UY25OgWJoBJRiYbXXQ3kbD0BhA5mlQlK6n9TKHhZXcgoGr7lKoq+62NACqAz54nJSup+FYGWc+RSWxXpr1JBi4GjFm0N3lwWT4tJTIx086hu5Lt9OyVBPLeYeEYOAyA2FRAsFgMsfKiaZ0Q47VxGoXEnMbmxAMXF6FcC8QOEE1sdhVoikkHucTEoKBywiEtgSCLiPOdEIynoykBXbLTaomrnU6rGBg8uV9d99sZ5XA+UMitiaPSwzBEJXEegiKawqJLvrT1g9G45ngwXlXV+1d4yqmTPfEpa1SJdvdt1fV3dQtvhqS766qVv/dpA8FZz8jW9TV4t46BC6tktjvbioh8XiZ13PqxnJ98bscEMshIOY+VYsznX3FNdO+0m3EFYXEfZXGIsZK4qKCYb8sunnVpLRbvTWXl9OJMIixhCne/hI+/2xnt/I6upfSeERUERNfTNd9KO1uXtUCAlUCHOtYb/K4WWwxs2n9uJlsV1P3sXJIQKBKgOMaZzalrqZSRaRrN11CMAgIXurMKSY9WJOAP4bdauuY7rp6mEYV8UnrGMaAGD+Aaa58cpVwW6oEmQDvZkSbT5i2A9YP56siui/5ADGLaV0Cwi32+NhJRRwzpqDCM6qIMmA9jkWc+iT8i1Y+b1el3pV+soeNOyZx+BgxuAyfcUJVVlnvt7EnWDx3lEtipJkl0UVw26bxh9WDcYjZB0Kc9dw16bhwfwQ4wglWmtHUloB42W6mo18rKQYUbxZ1uYaIbqY5Mo4AL/j3te1mygHxEleseLGL6OVriJQS6MwDKZwwEO5MP4VT2L/J0OptuaTRkZrYl7+66sGVf8YirqfGLesRBAKc50+wTP+OgEgVxBASX9pL0536A4z9ZJd+kanZH4xp/nWTqgSBANP4m0zt621brR5LQHzmQPXZ7sdw6ReZmu3BFzfMuc0VoEFlmGYVnyYD3eSB6pgM9KnXZuqm8CG2XU1xn9VHN+OeovF3ZLUyXE5AjKuqU0C8fX5ATOoObvX+8vAIiRIQERSVnDhDdRCBkNcg6C6Cyz+xe25ATPbWnvVeJbHoy40vlvO5GffZ9nuTpxyn6qBTHcAcA+Iy7vlc58Zq7MZIaySWefprmgKrmjhOGCx0FcH8AuLpLNHuEj9UWiPR1jkxoppYRyVR7YKCZ+zDCIISuCoDmG9ALNpdQGwuOBieVBNphlP1blCsclD0K9Nht1VBmQkWYWDMABjb0DS2e9OmGUwxzbW7xg/5TlBUuesph0W/fX7t3U9RVaX90OYwcFVT4GNtZ6yDaG/bKwyGDzSSbVu/c4XPKJli4GWz3nvcXGZgRLdQ0+49RhDoHQI+pz2pq3kEw8EP38QW3Sq7ymI/MNLjZnzcPT9Xko8/7/bnbnevLTQDjqmzCw4HxrZFfk8Khygs+n7veZW+5Mfy7/ae5zcO/O/qnM7bx9QPlp+nn6PevQYQDBMOjtyEH2jlAa6AuSkACAYABAMAggEAwQCAYABAMADwwsHwH7sBgOLXCIZf7AcAijcRDD/ZDwAUP0UwvB62v9oXALMXWfB6HHz+87D9adh+Hrbf7BuA2fittP1/LFlQ/U+AAQCcPu2yX4dYZQAAAABJRU5ErkJggg==);
    }
    .tm-icon{
        background-position: center;
        background-repeat: no-repeat;
        background-size: contain;
        position: absolute;
        top: 50%;
        right: 15px;
        transform: translateY(-50%);
    }
    .icon-one{
        width: 50px;
        height: 50px;
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDowMkU4MzBBM0YwRkYxMUU3QjA5MEE4NTA3MUFDQUZFQyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDowMkU4MzBBNEYwRkYxMUU3QjA5MEE4NTA3MUFDQUZFQyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjAyRTgzMEExRjBGRjExRTdCMDkwQTg1MDcxQUNBRkVDIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjAyRTgzMEEyRjBGRjExRTdCMDkwQTg1MDcxQUNBRkVDIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+1YPs9AAAAtxJREFUeNrsm71OG0EQx3fPZ5/tgC1iJEAE0VHwDlCgPECkPELqPAC8QBpeAKWP6CkoKGjSRaKigZYvia8YAmef72MzczqJD+OzLW53b+0ZNEI244/7eWb2PwNwIQQj6zYr4+f7Cn4GLiR6E/y7bDA844w5B59T8IHegjdMAqOyLrnuUloGP+qT3rot7b0dJteQecbsgX8e8NPTlTH9XncffC3rjFkZ4vl2wCPJQO7Afwz5mFUZGTNIFkwlp4UOmwc/zbon2Rm9uU3wdfArDVC2Bg0+dm9e3F6qNqRnjAnGhwFjMTKppZR7g2xZfNa8mwTmyTaS73hq/gQ/UDkrmTIfflE9RJpiM7ksJTzm7oI2uw885kVhfJ9jFVjNdljdLssdgvLafEOQB6fePQAJXtzfhtvtTgDAPPbJqbEC59rrTamde/+6oDw3/BnG5KERKbOHsMNakd83DmMwdmzAPIa+lFjjwYQikhJrPBibW1JijQczaZekxBoPpmIV2WSh/wVjDMaO1XE960xANjgpmeLEMWM5XTfsCitbdqx8O4nyLSXK94PmTFEOJgLFe+27sbIVb+y+UNhdgfLFFSCHrzpAmi5WmaVJASsBEwGIkzfGgN6zlGBNmKVaEL9QrkG989HsMbd+a2Aor7MIHzuyzRd7iY7H5h5M8A4VG2hSwLQMJzAEhsAYr2NmShPx8gn3u7hOwPWm6PELThR3uNbE6doBdVy17NEFgyq2zpwuERe9YqN7z6t9VnrKDOox1HwJDIGh4/pdhruWv3675zEso3lPFcvxzibXGYPrAaHwj6/wtfCDoFIytcd8LFbi9Fapg7CUct9jsNZl1TudSgSGwBAYEngk8EjgkZHAI4FHpURgCAyBITAEhsAQGLQL0y8yFOJBBphv4JemQomEaMGA+1uG8t1lKf8qd+zebI1rKbEUKNR8U8w18LpdFWB+GQbnEXxbxXT9J/GRsv8CDACBhCyni+ZhgQAAAABJRU5ErkJggg==);
    }
    .icon-two{
        width: 50px;
        height: 50px;
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDowQjNBNzA1NEYwRkYxMUU3OTc2QjlBQkJBMUMzREZDRSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDowQjNBNzA1NUYwRkYxMUU3OTc2QjlBQkJBMUMzREZDRSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjBCM0E3MDUyRjBGRjExRTc5NzZCOUFCQkExQzNERkNFIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjBCM0E3MDUzRjBGRjExRTc5NzZCOUFCQkExQzNERkNFIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+gqxtwwAABYtJREFUeNrsW8uS20QUbcmveVi2ZyYkcUJIAglFJat8AHwCRRWfwJoPgB9gw4YqNhR7ij0LfoBdqsiGKkgIeU0yL8/Y48f4LZt73FLU8ujpkWTJ0a3q8mjUevTRveeevi1J0+mUpXbe5IDP9yW1N9SmIbZTal+HDYwUsMfsUatG8EDr1HaS5DHViDx9Ow6hdI/aYxf3XrY53dtf2hgCB+YHah8nmEfvU/sxDGA+9XG+36hNQh5ok9p3Po/5zO9Fsh76FDz0qWjZ4vMleMR1D30yYQDjxb6n9g212hJA+clr50cH5u0HV8MH5iutpQJv1S37rgyUwuimQN6nKTCGfav9Imv+TO3PNJTOj/mLlGOs7UoKTJqVVgSY0z5jr5ppujZZa8DYCwIFpSBJYuxGydtxI8onOXlFPeZsxNjzUw4K7LjL2F7H/biTHmN/HzPWHa0gMAOVsWcNEhJzFZzDDgfIzjpDxnZbjKnkMc8I1JG6QsCMaVD/NfgvLEfz3YIQyLttCrGhRfioZg+bbTfDr45FAgwGgSc9GGvERlf9aIuxO1scIL3TC+rTG5uPfdkywHwbjgTgfmcFgHnd4oOZXZDI9kMCZJ28JZ/hAGW0u0CowDtUDYgahVd7YH3OwzPOV4kFBqQp8setCmObOWMbAN0sG9vIUjLd1VB1IWXysFet8EIqVGAQFvAW3apFxsoW9UD8D/tgNxQCh37fEOdMXIqkffKY2lnCdAzIElpFz0AlGvzVon1/7APfFPM8RCAAvdgBAbOzboRj7D0GT7yvcQC45FbZ/RgMEOaHWMFHR92EhBJ0R02/WYlziNcn2h/bE66dgcOmcQcGN7gr8MrlDR4efga5iEbyGnpLA+bojD91PYSqRZ+Ty8Fi123GGRhM8g4Efni/xHWLV0OKXlTuB61pAgUGoOhZCOFTLvgH9iIPJZbA4MYg5nS7pvg/R0Za/PoXOTZUYJCFpoK3iOrWLmyGc2EDTpIWHGAhYEUW2Onqgre8t+Hc92nDSMlKgU8m9XkUhOAiRFopxNBj2kODNKFX3LhF1CnzmmWWxXx6DRTzpY0YAtMSBqfkFw8HfVJ5zUeKx7WgqmUphqEklhvtuAVTBChiK4X6z4nBMR9Qir+yybdns2sHSQvvxGzdj4CMFJj+2JkEsf/IYRbcGxm/9TxXywAHfAMJ0BwYxK4Dsr1GfYrhFccDAUadOqdNP/MYEQCE1e0K10YAF9cBEGsRrG0EcglJGLxqgUJe5k9ZnbifaN0iFMEfGzkWqQUCTFY2NMlQteaCe5eMeu7Tunn/nW2DYwo2L4U9PuGgA1yUQ8MGKhBgwCs6IHbrPgBPsSFJxYU8sezy9rxSNKEUCHUVc2ZN4yrfZeu/7azRM/NO0Kk5NI8prxlVNwg9rA+VHLwAhKrXTypr7vWdYwGYciFBHIOniJjX3X2fNEvJ4U1/hI7iUXtgmURX1RBzevkzEaEEEwvdAKgWQB0WZC3Wd6Bd8pmEAQMXVwQ3f92+WLlxOLc0Cy6qKiwyC1Q3ouidlQ1ywBrz4QLrPpg6PKkbS7p6QT0nJxQY3DiWX2UBnL021yDNgbfQeUlg/tswlzixCBcV6QZejxEnkXe3zG82gHPw+ge8aTPPyRp/g0zHKtcp8JJz4pD2X1eCLyksBRgYMtQnO/xNBbHeAqBQhPLyhtlspl32nr0SAYxePEJlDiEEjdPzWMWHJ6ECeHkzGiEXOTBitkJDOAEkhAxCB96DhJOVuHfAy1BmKF2w0JUYYMTwinqGHJustEqWApMCkwKTApMCkwKTLGD2kz5IdcI6YQCDz4aPkgrKZMp6ex32RxjK93fm8KncowPvH4S/Mxwz/+V7CozZugkcdzcKYH5JGDgotv4axez6odZWyv4XYAAdmetEe8BogQAAAABJRU5ErkJggg==);
    }
    .icon-three{
        width: 50px;
        height: 50px;
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoxMkE0MjE1RUYwRkYxMUU3QjREQ0Q4NkRFRTVDNDc3MiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoxMkE0MjE1RkYwRkYxMUU3QjREQ0Q4NkRFRTVDNDc3MiI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjEyQTQyMTVDRjBGRjExRTdCNERDRDg2REVFNUM0NzcyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEyQTQyMTVERjBGRjExRTdCNERDRDg2REVFNUM0NzcyIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+fBPTuAAAAy9JREFUeNrsW8tO1GAUPnORm8AwEMCRQSRxYUh8BF0YH8DER3DtA+gLuPEFjHvj3oULF27cmbjBBSzVGRgYqMNVQZh6Pts6VAZopedvfzxfcjIpnP+0/9dzbdOc67qkOI58wvYesNRZXEFpsTySJiaXsMcssVQM3FCHZcwmYkzGZS7tUJpjWTzDvdPGadf2yd9D4h7zluVexLuXlsecdd53LHeT9pjbMey9ZmkLE7LB8jTmmjsSHhPFC8p+tUgDUyy1pHNSMaGLe8bymKWZAinPoyrPL4SPb92U9xgbkItDTJ4UoqGUebC3zBxJ3i0lpoMn/i+q5guWjyZnJVvmw/umh0hbMJl6KB0cEK1/I9rcJtrb59LA3cTQZb6ycaLenuP60Fnhor+1w+XQ9XSGB3li5E6paDDwRU+1scWd1zIH9ZFeGJvF30FU9QrRSKnzvxanxVrD0wnwY8+TNSa3ynN7acjO5zGdTW4SfamHSQk1R7z5r0ya49cH/OL4pLYKdmAPdq31GIRPvRFNF3oInzUnuv7ggHxYiXgMcko7xigZlZTAc2DfylBC/pCEtH0xYhAaktj/aSkx+QvQHYlsoVt/YpN9MWLQkEnCRC8jQszoCFGhIHPBsAv7VhKDi69MyFww7EqRbqTzLZeSd3nYK5csHwkAzDb9fcnYgp1qhYxBlBiU7evTRH2957OD9bBjsg0QP1WR88HsNaKB/n9bj3VYXyyQURi5B7/J4Ts+HDPnQB/rTJNijJggrGamvAdOUQA96KfVRRt/GH510kukSyvdJ3AQAR1T1SczxASlHOR8roUHwp5L7CXV8ydrq0KpW6W5Mes92oSX4BfHWSAlNY/50yEzIdPoTSqUOegrWiVGiVFilBibqxJeqzadk1+YJQ286h0f9V71ZtpjVtfNkQLgXE1HQ8neHDMx5rm3KQShlPkcg1iXinetSkqMEqPEaIOnDZ42eApt8LTB01BSYpQYJUaJUWKUGCUGWLZ9k4eHtC1BzEOMQraS0m7T90aT3kt0vm/olE/l5heifxD+3+SYvz/wVmLC2LVw37smiHlpGTk7LK9MTNcffLlQ+CXAAIf79Ho7v7bzAAAAAElFTkSuQmCC);
    }
    .icon-four{
        width: 50px;
        height: 50px;
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoxOUJGM0MxMUYwRkYxMUU3QUI4RkQ5NTA1RTM3RjBBQiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoxOUJGM0MxMkYwRkYxMUU3QUI4RkQ5NTA1RTM3RjBBQiI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjE5QkYzQzBGRjBGRjExRTdBQjhGRDk1MDVFMzdGMEFCIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjE5QkYzQzEwRjBGRjExRTdBQjhGRDk1MDVFMzdGMEFCIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+9zmoMQAAAoFJREFUeNrsm71O21AUx8+NDSSRGJKCUNWhGwPvQIeqD1Cpj9C5DwAvwMILIPaqeweGDl26VWJigZlSqUQBJOokYOdyDnJFqmDHQfde+5r/kf7Kl3yv/cv5tBKltSbYtDUMr/eB9YulLeqS9ck2GGXYY85YLx18oX3WC5/AuIxLVXYobbCOZ7h32ZZ3bkfpNRj3mG+sdwW/vbI8Zta+31lvTXvM5hzrfWWNLQO5Yu3MecwbGx5TxAs6abUow16xTk3npNDQye2ytljnJUDZK1zKTkb/ve6uL1n3GB9MzQOmQTCroVR5Y295PZG8LwHmwbbTR6ma+6xDl7OSL/Ph+8p6zLCf0KAfk067HsWn2+qG1OwGLrZfcz1dF7Lxraao9wDlvvTxc3lPPqvjbYdiYGL9pM9qD8aXRAQDGICpducriTS5mU6mySg7wcZDTVpP37kIFhU1QuU/GOlTpPzOa9F59jHtFWd9jr1QkubN+JoXsTOPsQZGW7iPpxMk3/pWJWVhZRXUAIwMhMbX7Libea3tJNVjcblBye3j5Tqr+rRXQwqWpstysMDleqEG5freHTMuRqnszBw2FYWt8lMfki/AAAzA1A5M3jCoAvWMwXClkoFwsgmU5k3ekym69rcdZvU5riZl5BiAARiAARhPzFhVGvRiGl4k5OqH5oqrerMTUGslrLbHuIQiJnvJngglX3OMuLVy2LT+C6XK5xiJdVvxjqoEMAADMGjw0OChwYOhwUODh1ACGIABGIABGIABGLHfvl+kTujaBpiPrD/eQhnTIOrFP2x0vgeU81e5/slo77mGEuVAQfLNscjD645cgPnsGZy/rC8upuufqWpldwIMAN3e45sYTJOqAAAAAElFTkSuQmCC);
    }
    .big-tit{
        font-size: 18px;
        color: #333333;
        padding: 0 15px;
    }
    .big-con{
        height: 60px;
        line-height: 60px;
        background: #fff;
    }
    .bt-icon{
        width: 20px;
        height: 20px;
        display: inline-block;
        vertical-align: middle;
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
        margin: 0 20px;
    }
    .bt-txt{
        vertical-align: middle;
    }
    .bt-i-one{
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo1MzA3MzgxNDZCOTcxMUU3OTJGNkE2NkFGMDY4MzJFOCIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo1MzA3MzgxNTZCOTcxMUU3OTJGNkE2NkFGMDY4MzJFOCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjUzMDczODEyNkI5NzExRTc5MkY2QTY2QUYwNjgzMkU4IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjUzMDczODEzNkI5NzExRTc5MkY2QTY2QUYwNjgzMkU4Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+PrNSewAAAgVJREFUeNqslEtI1FEUh2cGJcXwhQbaQhjRhQuFkBwhqAgESTMwfCC5GC1iWjju3ApuBTcDIS5aFKVioJHC0MN2JUXQViNqkWBD+IgKF07fkXPl8Pc/zIBe+Dj3ce7vvs65wXQ6HTjNEvQTbPscL8D0QhdE4JwObcE7WITZZOPUv6yCiLVhpqEmy2a+wV1EkxkFEbuHSUDIM3keCqHD038A9xF9cEwQMTniU5+dLMAY5MEEdPv43EJ04UgQsQrqG1CS4XgzUAT9GcZ/QS2i2+5od3zEvsIn2IdhFduD97Du8S2HoYC5qxtmMAVXWS0MF6if1zt8CNX0RaCeeitsmnndVrDBDPQzYdU1qKc0hKLUfxu/7zBo2ocaedoodnHGpJeeeJTruARnaAf0tcPwEd8++n5Sr3RX5gR3VTSEQxDHNFYc3kKT+vxRsaC24/iEjMaOPfIXtfLa17U+CXJXr+CDTnBib2BZr6JM+9at4KK5i8esfBNbB6/hMjRDlY5LXw9c0YwKWA0nmHBb1qPPQam+4jiMyqOIMNdxDdsCL+CsicOEN1P6ME/MipL4vQgseXJddvcI8v0yJWTCQ9IupvkpRV74GQK3jVhUF803uRxzYpl+m3ZNtWrTPaIPMmX6fkgGIbaSy38o4TEAnXBR40yKxNwaPJfHQ+xvTh/sqf/YJyn/BRgAjFO07gcEvDsAAAAASUVORK5CYII=);
    }
    .bt-i-two{
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo2MDg3MTMxRTZCOTcxMUU3OUVGQ0M0MDU0QTkxRTc3NyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo2MDg3MTMxRjZCOTcxMUU3OUVGQ0M0MDU0QTkxRTc3NyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjYwODcxMzFDNkI5NzExRTc5RUZDQzQwNTRBOTFFNzc3IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjYwODcxMzFENkI5NzExRTc5RUZDQzQwNTRBOTFFNzc3Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+9SBONAAAAYFJREFUeNqslD1Iw0AUxxPrB3RwcBBFxEEEvxaVjkIRxFXcXB2qmyAOToqj6Cg4KhQnB9FNBEFokVpQFxVsETRQFUXHutj4O7jAI1xMGnzw43/3evnfu3dpbNd1LRWTt8UNZBkarPBQD+2dDqXm/D/YwvDHYPYFb9AObQbjbmjG+NFLSAM5fodx/cAuDMAYXPgMG+HOCjCRUWHXHFrzjsj8Cr00rG3x72CKBC1YQEdVW2CF+QfaGtbcIMM+eKGqjJfAsAc5CzMMOvIxZkcywfwJWY9rOE1FIzLBXJ1mNa5hE2xikhS5NeiN28Oa3qyAaR4d1PPPgPfxzwrvoZ+eTaDnMA/D6tTQBdv1GmYwK+lxVusBuSp8M16Eh6iG6u+XFzdbQIqwI3KqHbmoPUzAFn1zRK4MaXJpUcSU6HXopSwZcrOG3Ak4YYYzcB3h86Uqczi+S+XBhiw4ZEGFYWcE01fTOvk9VIMUPEMygmEVOuCGQmxThVl9o/XGvrHC/4pfAQYACjB342tNLg0AAAAASUVORK5CYII=);
    }
    .bt-i-three{
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozNTEyMDRBODZCOTcxMUU3QTlGM0I5MDJBREIxRjk2QiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozNTEyMDRBOTZCOTcxMUU3QTlGM0I5MDJBREIxRjk2QiI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjM1MTIwNEE2NkI5NzExRTdBOUYzQjkwMkFEQjFGOTZCIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjM1MTIwNEE3NkI5NzExRTdBOUYzQjkwMkFEQjFGOTZCIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+eJV/+wAAAVZJREFUeNpi/L83hgEKNIH4KBALMpAP9jMhccwoNAwEHJENZCSg+D8QvyVkIsjAJiA+AMQVBNTWAbE4EN/Cp4gFiKuAmJkI7zwB4r9A/ByI1fAZmAvEzkCsBMSGaPL/gDgGasgNqFgBEAsAcSIQx2Hz8nQgDgHiSVgsBBl4F4gvAPE7qNgdIL4CxC9xhSGhIDkJxO+BOAoqtgWIXwNxKS4N/ECsC8QaBAwXQaOxAkZgwn4EpGWJiJRfQHwTajneZEMsYCNkGMzLekCsA8Q+QFyORU0DED/EIh4M1YNh4AcgPgLEKjgszQbib3jCFMNAXACUXL7gkf8ApeWh6RJuYAoQ22BxYTMQfyQibP2giRwey3+IzHpEAZAL24HYFoglgFgdSS4TiH8QYYYDEMcjuxDGTgDi+UgKn0PTHiEgBMS82CLlH5pCSXK8jJywTyAVAOSCvQABBgBCqz8ctnGrVQAAAABJRU5ErkJggg==);
    }
    .bt-i-four{
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozQjM3OTgzMzZCOTcxMUU3ODcxMkVDNkVBNzdGM0ZFQyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozQjM3OTgzNDZCOTcxMUU3ODcxMkVDNkVBNzdGM0ZFQyI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjNCMzc5ODMxNkI5NzExRTc4NzEyRUM2RUE3N0YzRkVDIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjNCMzc5ODMyNkI5NzExRTc4NzEyRUM2RUE3N0YzRkVDIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+plllKAAAAVxJREFUeNqslDtIBDEURbPLiiCsndiJFgqCoBY22mi1gr/GytJGS1kb3dLORhtB/DSCoFhaqQhaidjogpaKoIWFIKz4Y8HxBN7AzJCZZAcvHF54SW5eMplkPM9TcSqvqCVCCW5gqLuo3pVFmaghJnlCEbpgDOql60KMtzG+thpiNEgYhgL0JBTxBVt6CjxpDxY4CRliNkd7FY7hRdmVhUnQla5BC6bLuiMnA0oSdWXfyk36KPphEeYhZNgksdkw8Q46oC7GuBU+g6Xb1AtHlu3/uhieww5nUyWewi782FbPJfRtwKW098V0ANrSGu75NwE2YUI5fv5EcaVmCZ2OXz6xQl/rqgZl1T8rrsI3qBjyDYE7W5PhA9wa8u1pDV/h0ZBvTLvlgpD6DKuRf/UQzgzj+2AqkqvI2YYM9bM1Ghg0LtikH4V7eI5em2k4gA/HnelxV7AAIzDjd/wJMADT2EzT7yjnzQAAAABJRU5ErkJggg==);
    }
    .charts-con-new,.charts-con-jd,.charts-con-rk,.charts-con-cj{
        height: 50vh;
    }
    .cd-label{
        font-size: 17px;
        font-weight: 600;
    }
    .cd-num{
        padding-left: 15px;
        padding-top: 10px;
        font-size: 17px;
        font-weight: 600;
    }
</style>