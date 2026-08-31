document.addEventListener('DOMContentLoaded', () => {
  // Mobile menu toggle
  const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
  const navLinks = document.querySelector('.nav-links');

  if (mobileMenuBtn && navLinks) {
    mobileMenuBtn.addEventListener('click', () => {
      navLinks.classList.toggle('active');
    });
  }

  // Hero Phone Mockup Quiz Logic
  const options = document.querySelectorAll('.mockup-option');
  const timerBadge = document.querySelector('.timer-badge');
  let seconds = 45;

  // Countdown timer simulation inside phone mockup
  setInterval(() => {
    if (seconds > 0) {
      seconds--;
      const min = Math.floor(seconds / 60).toString().padStart(2, '0');
      const sec = (seconds % 60).toString().padStart(2, '0');
      if (timerBadge) timerBadge.textContent = `${min}:${sec}`;
    } else {
      seconds = 45;
    }
  }, 1000);

  // Quiz option click feedback
  options.forEach(option => {
    option.addEventListener('click', () => {
      // Clear previous selections
      options.forEach(opt => {
        opt.classList.remove('selected-correct', 'selected-wrong');
      });

      const isCorrect = option.getAttribute('data-correct') === 'true';
      if (isCorrect) {
        option.classList.add('selected-correct');
      } else {
        option.classList.add('selected-wrong');
        // highlight correct answer
        const correctOpt = document.querySelector('.mockup-option[data-correct="true"]');
        if (correctOpt) correctOpt.classList.add('selected-correct');
      }
    });
  });

  // BDApps Subscription Modal Popup Logic (Triggered by Start now button)
  const startNowBtn = document.getElementById('startNowBtn');
  const subscriptionModal = document.getElementById('subscriptionModal');
  const modalGoBack = document.getElementById('modalGoBack');
  const otpGoBack = document.getElementById('otpGoBack');
  const sendOtpBtn = document.getElementById('sendOtpBtn');
  const verifyOtpBtn = document.getElementById('verifyOtpBtn');

  const stepPhone = document.getElementById('stepPhone');
  const stepOtp = document.getElementById('stepOtp');
  const stepSuccess = document.getElementById('stepSuccess');

  function openModal(e) {
    if (e) e.preventDefault();
    if (subscriptionModal) {
      stepPhone.classList.add('active');
      stepOtp.classList.remove('active');
      stepSuccess.classList.remove('active');
      subscriptionModal.classList.add('active');
    }
  }

  function closeModal(e) {
    if (e) e.preventDefault();
    if (subscriptionModal) {
      subscriptionModal.classList.remove('active');
    }
  }

  if (startNowBtn) startNowBtn.addEventListener('click', openModal);
  if (modalGoBack) modalGoBack.addEventListener('click', closeModal);
  if (sendOtpBtn) {
    sendOtpBtn.addEventListener('click', () => {
      const msisdn = document.getElementById('msisdn').value.trim();
      if (msisdn.length < 10) {
        alert('Please enter a valid Robi or Cirkle mobile number (e.g. 018XXXXXXXX).');
        return;
      }
      stepPhone.classList.remove('active');
      stepOtp.classList.add('active');
    });
  }

  if (verifyOtpBtn) {
    verifyOtpBtn.addEventListener('click', () => {
      const otp = document.getElementById('otp').value.trim();
      if (otp.length < 4) {
        alert('Please enter the OTP sent to your phone.');
        return;
      }
      stepOtp.classList.remove('active');
      stepSuccess.classList.add('active');
      setTimeout(() => {
        if (subscriptionModal) subscriptionModal.classList.remove('active');
      }, 2500);
    });
  }

  // Download Verification Modal Popup Logic (Matching User Screenshot)
  const downloadModal = document.getElementById('downloadModal');
  const dlStepPhone = document.getElementById('dlStepPhone');
  const dlStepOtp = document.getElementById('dlStepOtp');
  const verifyDownloadBtn = document.getElementById('verifyDownloadBtn');
  const confirmDownloadBtn = document.getElementById('confirmDownloadBtn');
  const dlGoBack = document.getElementById('dlGoBack');
  const dlOtpGoBack = document.getElementById('dlOtpGoBack');

  const downloadButtons = document.querySelectorAll('#headerDownloadBtn, #heroDownloadBtn, #downloadBtn');
  downloadButtons.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      if (downloadModal) {
        dlStepPhone.classList.add('active');
        dlStepOtp.classList.remove('active');
        downloadModal.classList.add('active');
      }
    });
  });

  if (dlGoBack) {
    dlGoBack.addEventListener('click', (e) => {
      e.preventDefault();
      if (downloadModal) downloadModal.classList.remove('active');
    });
  }

  if (dlOtpGoBack) {
    dlOtpGoBack.addEventListener('click', (e) => {
      e.preventDefault();
      dlStepOtp.classList.remove('active');
      dlStepPhone.classList.add('active');
    });
  }

  function triggerApkDownload() {
    const a = document.createElement('a');
    a.href = 'assets/quiz_master.apk';
    a.download = 'quiz_master.apk';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    showToast('Downloading Quiz Master APK...');
  }

  if (verifyDownloadBtn) {
    verifyDownloadBtn.addEventListener('click', () => {
      const dlMsisdn = document.getElementById('dlMsisdn').value.trim();
      if (dlMsisdn.length < 10) {
        alert('Please enter a valid Robi or Cirkle mobile number (e.g. 018XXXXXXXX).');
        return;
      }
      dlStepPhone.classList.remove('active');
      dlStepOtp.classList.add('active');
    });
  }

  if (confirmDownloadBtn) {
    confirmDownloadBtn.addEventListener('click', () => {
      const dlOtp = document.getElementById('dlOtp').value.trim();
      if (dlOtp.length < 4) {
        alert('Please enter the OTP code sent to your mobile.');
        return;
      }
      if (downloadModal) downloadModal.classList.remove('active');
      triggerApkDownload();
    });
  }

  function showToast(message) {
    let toast = document.querySelector('.download-toast');
    if (!toast) {
      toast = document.createElement('div');
      toast.className = 'download-toast';
      document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(() => {
      toast.classList.remove('show');
    }, 3000);
  }
});
