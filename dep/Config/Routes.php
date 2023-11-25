<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');

$routes->get('/webcontrol', 'WebController::index');
$routes->get('/toggle-sass', 'WebController::toggleSass');

