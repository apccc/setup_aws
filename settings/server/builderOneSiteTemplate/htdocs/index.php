<?php
$section=(!empty($_GET['section'])?preg_replace('~[^a-zA-Z0-9_-]~','',$_GET['section']):'index');
$page=(!empty($_GET['page'])?preg_replace('~[^a-zA-Z0-9_-]~','',$_GET['page']):'index');
$sectionIdentifier=$section;
$pageIdentifier='php_'.$page;
include dirname(__FILE__).'/sitePage.php';
?>
