
use strict;
use warnings;
use Test::More;


use Crypt::NaCl::Sodium qw(:utils);

my $crypto_generichash = Crypt::NaCl::Sodium->generichash();

my (@k, @in);

ok($crypto_generichash->$_ > 0, "$_ > 0") for qw( BYTES BYTES_MIN BYTES_MAX KEYBYTES KEYBYTES_MIN KEYBYTES_MAX );

my $bytes_min = $crypto_generichash->BYTES_MIN;
my $bytes_max = $crypto_generichash->BYTES_MAX;
my $keybytes_max = $crypto_generichash->KEYBYTES_MAX;

for ( 0 .. $bytes_max - 1 ) {
    $in[$_] = chr($_);
}
for ( 0 .. $keybytes_max - 1 ) {
    $k[$_] = chr($_);
}

my $key = join('', @k);
my $msg = join('', @in);

my @tests = getTestData();

for my $bytes ( $bytes_min .. $bytes_max ) {
    my $i = $bytes - 1;

    my $subkey = substr($key, 0, 1 + $i % $keybytes_max);
    my $submsg = substr($msg, 0, $i);

    my $hasher = $crypto_generichash->init(
        key => $subkey,
        bytes => $bytes
    );
    ok($hasher, "initialized hasher for $bytes bytes");

    for ( 1 .. 3 ) {
        ok($hasher->update($submsg), "mac updated $_");
    }

    my $mac = $hasher->final();
    is(bin2hex($mac), $tests[$i], "correct mac for $bytes bytes");
}

eval {
    $crypto_generichash->init( bytes => 0 );
};
like($@, qr/Invalid bytes value: 0/, "bytes out of range for 0");

eval {
    $crypto_generichash->init( bytes => $crypto_generichash->BYTES_MAX + 1 );
};
like($@, qr/Invalid bytes value: 65/, "bytes out of range for BYTES_MAX + 1");

eval {
    $crypto_generichash->init( key => "\0" x ($crypto_generichash->KEYBYTES_MAX + 1) );
};
like($@, qr/Invalid key/, "Invalid key");

ok($crypto_generichash->init( bytes => $crypto_generichash->BYTES_MAX ),
    "key can be empty");

done_testing();

sub getTestData {
    return qw(
05
22a8
287a9d
d8eeab1c
d4ce34973f
584f7ac46f0c
32c848bb67545b
8438e21361bca125
27a6faae998b4fabb4
508c05a4f2daee150bad
68c886c97dce370e8c72fa
d41e90824ace31ba7bf512ac
6e0d7a1e2b92a68e45ea867895
1fc5ee8715312db38da9066152a5
3138504ba58fcd56c62752bc98a6d2
b689ecd5357cb5276007627fbdf4082e
afe251881beb8b9dfa3d4f76aafc7b2995
980eaa215cb0911027c5564db809bb8ac0a1
56048436883efdfc8feaa239d960fa5ce24d42
fce905b6d57fd841f58899a77887a4988e6aa2d1
6f7afd81d24ccf4d98188b71bdbb7e6c637620879b
50406b4c37b48621505942b35dff30a75f7d2868146b
32c21792e18e7a79a4a20ef291721d7eab4e4cf99fbe79
4b9d9ac5dbfb825acd87588667e6683e0fde4cdcd0a532f9
2b55a3ebb461623e5de4fbacfb8b26819cfa8adeb094c8c13b
4c7d261780b25a864a008352ad64d1ae7fc21d608317813cf63f
f0ca06b8e12c48f1511d0991ba562f06dbe6ba6d5e18280224cc6a
838a5f7056bfbca65a245796dd3510cb07ff1614b44989d91ac650b2
a58a8da276577160441f8b9e9c52a041b7caf7cd316acc506f620ab0e1
e03940a7231049ff2b86c47a28e4951f105d2a3aa3421190fe0ed6aa4ad6
a7af977c0b34294b1a03d0cc2dcf6eb72f9a32721c3f70128384aeb1f56047
0e5625d74ada70b8a3b23ca76894e9a0f9dee88f5e3e370e27ad25061ea9dd6f
775fd9257b265997a16557a445985091798af60e68d06e3ae8e2e886d23ed12f6e
852e8d4208166a990e215ed06b86c708f491e014584ac9b08f97f24d9f08a84c8e83
fbdca0db9a933fcffcce2ae694d7e16e7571b100564fcb3d69cec82ea42f254a493a32
50530ae5eb9780f3fafc5d179f7b363a0d69314a8545d68588b5fec28c8e8d1a011857f6
5eb71553ff1ac4aba3f84faeb70281c738e3428aae68edc9842ebf55ffd7184a015e323445
39b279c6d9cca89f8052f953abf71041faf3491b2b965cef503d715e8bf339e02a58fd0e0fba
e315bef5f4918e881dc8d39d3c6b3948c2ea8e21ac00ee7c7ab875a53e194add0c3d9b8bcba5b2
4e950f0e1da3111d054136fbdf10b4b88b20de6ad0c6bd5024a5e0a8b4cd7059685c0b663a00cbfa
b1ed8d99fd62a4f504ecdd58a01759a85932a7783f88f314cdca5019e05063dcc1fcb3c39b8c07758e
e4d78e734b0cb5bbd83e22bc67f97bbc8a3644f789f6c26a3ec2fe72c75b4d48a3bc000e6f2f2f0726fe
162e01beb796433a2771eab54611fc93677ed12c73a93ea4d75e148bec7ab14b3e31ab7f395456fb2b47ab
759c30631fd52e80a22f0614125dcd136287db65079908b75fb5b03be1cdf6dd0a1c9de0cc759cdd82c33758
af2992acdaf0908f03a2025854de6446123c919b1e24db711df6cb070091343b4e6f5b2716c20c2547f50f1fde
b833064955778a611fe41a9f1a2de730a16fb4e61a7e2fb67425ce199101d4e71dd7b0c731ea4188e9cc30e9bc52
e546ee327168d9b4e0d73d9a043f9ef03f880bc8aee91b0923704eb7361ac916b00f5c71c872e2f911a77ef76704b5
83d86f056729fa1a6e1d3fe8c3d2ebe42b327025747f2e6ba923d2b7b893e31571839937222852033844e585b17d462f
5d70402524fbef569552a3ff6854087e090ff9ac9ea03aba92cf9f33a28845fa6a1631090dca10e05cdd3341b391a15fcf
64f4d3ebf0717900f7c04512d1e18f9985975991d4254d76c4e2ee02c0edd6f912f715991984731b808b8370be1f201e53bf
7d45eae6626dfc9ec3591764b8c39c72ca67e6c1893ab590963a75922719937d1d0ff188a510ffbdf9c777a4d565b3683cbf38
68e007db5067874548c0d12a9ca709221f9bd352e3eb9847fde6c5de4a8550f4b85b67fe4e5aad70626ebb27d71e5b528effb2e6
b0dc4dc0bd0d41a8ccfa45a127542079bc4e6f63a63863a9ce21f44481d23eff1060ea03851759b9317209405d5b7cc4387cc2759b
adf6a9df484e93eb3a6113c3fd68a49b2166878fc652833c9cbef3fd8dd281d385ad0374bc25bc865b216ca395e21c30b9eda1d58a8d
f1df9bc169323da338daa8a94867db96a1a2a6feb26569198fb4591ae602ba6f766a879e745d71e93b6cb8886b914f2bf4aa55d4c48045
0c7446078a5077f33bba1ebfad60bbf1b1df47aab2eb3f3f3274ce56ead7800cf095af8208b6d570c4c832fe33227bbbc0842a13e1e82ad9
accd0b4682e56698ecc55a60a8db8b3f950b6bffc5a1d160daf6ca25e13e3b4983ced5903df0bdc21f70c2ec5adb1a2ec9617df645cdd17ac9
b787bae190ff2608eb383e0299cc10d6b7232de67ab74285e7bfa933d79f91226066537d74a9d40140d7b1683c2d42cd1935f6430cc554db2b69
d09b717a0c80f581c07b8813e0ae79cec2188f77122f7477954610655a20420f13eb1b68cacde8c1fdf7a9a398efa72f40c85f0122812eaa33aba0
87fff156d9895917468e92848fdcfacc134ca3bfc7fce484bd6db41c682ee2ee47151df0fa863d5641633d908c0328e6cbe080e80d8293530ffd2c4f
1b17b2c0e7afcd224ec9bbe9ce9a13a00bd0a336b863f1b4d5304043778244323bd23fb6154a2e1e94aa48f6ff0e12787a50ca09e9e72ece9e038f6218
23ac1ccd5e7df51b65b284650158d662e7ef51ebae01b879f39cec484b688c792f8e854bd8ca31ffe8796d28f10e49ab402dab47878a21cb95556dc32b0a
f8f5323ebcc28bf927e72d342b5b70d80ba67794afb4c28debad21b0dae24c7a9252e862eb4b83bea6d9c0bb7c108983c987f13d73f250c7f14483f0454a24
55b97ca594d68ccf69a0a93fe7fa4004c7e2947a8cac4ca4a44e17ac6876f472e3f221b341a28004cd35a79cfad7fabb9378ce5af03e4c0445ebbe9540943bbd
    );
}