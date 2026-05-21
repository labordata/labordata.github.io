---
title: Archive
layout: default
---

<h1>Archive</h1>

<ul class="archive-list">
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <span class="post-meta">{{ post.date | date: '%B %d, %Y' }}</span>
    </li>
  {% endfor %}
</ul>
