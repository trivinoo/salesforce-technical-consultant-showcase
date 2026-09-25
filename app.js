document.addEventListener('DOMContentLoaded', () => {
    // Tab switching logic
    const tabBtns = document.querySelectorAll('.tab-btn');
    const panels = document.querySelectorAll('.panel');

    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(b => b.classList.remove('active'));
            panels.forEach(p => p.classList.remove('active'));

            btn.classList.add('active');
            const target = btn.getAttribute('data-tab');
            document.getElementById(target).classList.add('active');
        });
    });

    // SFDX Terminal Simulator
    const runBtn = document.getElementById('run-sfdx-btn');
    const termOutput = document.getElementById('terminal-output');

    if (runBtn && termOutput) {
        runBtn.addEventListener('click', () => {
            termOutput.textContent = '$ sf project deploy start --target-org dev-org\n';
            termOutput.textContent += '[1/3] Validating Apex Classes and Metadata...\n';
            
            setTimeout(() => {
                termOutput.textContent += '  ✔ OrderCreditCheckService.cls (Syntax OK)\n';
                termOutput.textContent += '  ✔ OrderTriggerHandler.cls (Syntax OK)\n';
                termOutput.textContent += '  ✔ OrderCreditCheckTest.cls (Syntax OK)\n';
                termOutput.textContent += '  ✔ orderCreditStatus LWC Bundle (Compiled OK)\n';
                termOutput.textContent += '\n[2/3] Running Apex Unit Tests...\n';
            }, 800);

            setTimeout(() => {
                termOutput.textContent += '  PASS  OrderCreditCheckTest.testApprovedAccountOrderCreation\n';
                termOutput.textContent += '  PASS  OrderCreditCheckTest.testBlockedAccountOrderCreationPrevention\n';
                termOutput.textContent += '  Coverage: 100% (OrderCreditCheckService, OrderTriggerHandler)\n';
                termOutput.textContent += '\n[3/3] Deployment Status: SUCCESS 🎉\n';
                termOutput.textContent += 'Deployed 8 items to Salesforce Org: dev-org\n';
            }, 1800);
        });
    }
});
