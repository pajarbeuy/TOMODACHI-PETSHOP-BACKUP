@extends('layout')

@section('title', 'Login')

@section('content')
<div class="login-container">
    <div class="login-card">
        <div class="login-header">
            <div class="login-logo">
                <img src="{{ asset('images/logo.png') }}" alt="Tomodachi" style="width: 100%; height: 100%; object-fit: cover;">
            </div>
            <h1>Tomodachi Petshop</h1>
            <p class="subtitle">Sistem Manajemen Toko Hewan Peliharaan</p>
        </div>

        <form method="POST" action="{{ route('do-login') }}">
            @csrf
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Masukkan email Anda" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Masukkan password Anda" required>
            </div>

            <button type="submit" class="btn" style="width: 100%; justify-content: center;">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>

            <div style="text-align: center; margin-top: 20px; color: var(--gray); font-size: 13px;">
                Demo: gunakan email & password apapun
            </div>
        </form>
    </div>
</div>
@endsection
